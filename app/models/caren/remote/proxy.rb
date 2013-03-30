module Caren
  module Remote
    class Proxy

      def initialize klass, array_root, node_root, properties
        @klass = klass
        @array_root = array_root
        @node_root = node_root
        @properties = properties
        @storage_context = Caren::StorageContext.api
      end

      def all session, success, failure=nil
        session.get resourcesPath, nil,
                    lambda{ |request,response,doc| handleXml(doc,success) },
                    lambda{ |request,response,error,doc| failure.call(doc) if failure }
      end

      def create session, caren_object, success, failure=nil
        session.post resourcesPath, self.class.serialize(caren_object),
                     lambda{ |request,response,doc| handleXml(doc,success) },
                     lambda{ |request,response,error,doc| failure.call(doc) if failure }
      end

      def import session
        all session, (lambda do |objects|
          # Marks the extra objects for deletion
          (@klass.all - objects).map(&:destroy)
          # And... Commit the save
          @storage_context.persist!
        end)
      end

      def self.serialize caren_object
        doc = DDXMLDocument.alloc.initWithXMLString("<#{caren_object.class.node_root}/>", options:0, error:nil)
        caren_object.class.properties.each do |key, options|
          value = caren_object.send(key)
          case options[:type]
          when NSBooleanAttributeType
            if value.present?
              value = (value == 1 ? "true" : "false")
            else
              value = nil
            end
          when NSDateAttributeType
            formatter = NSDateFormatter.alloc.init
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
            value = formatter.stringFromDate(value)
          else
            value = value.to_s
          end
          doc.rootElement.addChild( DDXMLNode.elementWithName(key, stringValue: value) )
        end
        doc.XMLData
      end

      def resourcesPath
        "/api/#{@array_root}"
      end

      def resourcePath id
        "#{resources_path}/#{id}"
      end

      def fromXml doc
        errorPtr = Pointer.new(:object)
        arrayNodes  = doc.nodesForXPath("//#{@array_root}/#{@node_root}", error: errorPtr)
        singleNodes = doc.nodesForXPath("//#{@node_root}", error: errorPtr)
        if arrayNodes.length > 0
          return arrayNodes.map{ |n| objectFromNode(n) }
        elsif singleNodes.length > 0
          return objectFromNode(singleNodes.first)
        else
          raise "Unexpected response"
        end
        nil
      end

      def xmlToKey xml
        xml.to_s.gsub("-","_").camelize(false)
      end

      def objectFromNode node
        attributes = {}
        node.children.each do |child_node|
          key = xmlToKey(child_node.name)
          if @properties.keys.include?(key.to_sym)
            value = child_node.stringValue
            case @properties[key.to_sym][:type]
            when NSInteger64AttributeType, NSInteger32AttributeType, NSInteger16AttributeType
              value = value.to_i
            when NSBooleanAttributeType
              if value.present?
                value = (value == "true")
              else
                value = nil
              end
            when NSDateAttributeType
              formatter = NSDateFormatter.alloc.init
              formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
              value = formatter.dateFromString value
            end
            attributes[key.to_sym] = value
          end
        end
        @klass.new(@storage_context.find_or_initialize_instance(@node_root,attributes[:id])).tap do |object|
          object.attributes = attributes
        end
      end

      private

      # We convert the XML to internal objects and run the callback.
      # The callback is allowed to save the context, after which it is
      # automatically cleared
      def handleXml doc, callback
        object = fromXml(doc)
        callback.call(object, @storage_context)
        @storage_context.reset!
      end

    end
  end
end
