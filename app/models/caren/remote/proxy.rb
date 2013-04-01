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

      def all session, &block
        session.get resourcesPath, successCallback(block), failureCallback(block)
      end

      def find session, id, &block
        session.get resourcePath(id), successCallback(block), failureCallback(block)
      end

      def create session, carenObject, &block
        session.post resourcesPath, self.class.serialize(carenObject), successCallback(block), failureCallback(block)
      end

      def update session, carenObject, &block
        session.put resourcePath(carenObject.id), self.class.serialize(carenObject), successCallback(block), failureCallback(block)
      end

      def destroy session, carenObject, &block
        session.delete resourcePath(carenObject.id), successCallback(block), failureCallback(block)
      end

      def import session
        all(session) do |objects, context, error|
          if error
            # Handle error
          else
            # Marks the extra objects for deletion and persist!
            (@klass.all - objects).map(&:destroy)
            @storage_context.persist!
          end
        end
      end

      def self.serialize caren_object
        doc = DDXMLDocument.alloc.initWithXMLString("<#{caren_object.class.node_root}/>", options:0, error:nil)
        caren_object.class.properties.each do |key, options|
          next if options[:readonly]
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
          end
          doc.rootElement.addChild( DDXMLNode.elementWithName(key, stringValue: value.to_s) ) unless value.nil?
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

      def successCallback(block)
        lambda do |request,response,doc|
          object = fromXml(doc)
          block.call(object, @storage_context, nil)
          @storage_context.reset!
        end
      end

      def failureCallback(block)
        lambda do |request,response,error,doc|
          block.call(nil, @storage_context, error)
        end
      end

    end
  end
end
