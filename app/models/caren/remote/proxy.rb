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

      def import session
        session.get resourcesPath, nil, lambda{ |request,response,doc| importXml(doc) }, lambda{ |request,response,error,doc| puts doc }
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

      def importXml doc
        puts doc.XMLData
        # Puts the new or updated objects on the save stack
        objects = fromXml(doc)

        # Marks the extra objects for deletion
        (@klass.all - objects).map(&:destroy)

        # Commit the save
        @storage_context.persist!
      end

    end
  end
end
