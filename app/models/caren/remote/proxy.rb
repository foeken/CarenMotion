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
        session.get resources_path, nil, lambda{ |request,response,doc| import_xml(doc) }, lambda{ |request,response,error,doc| puts doc ; puts 'aap' }
      end

      def resources_path
        "/api/#{@array_root}"
      end

      def resource_path id
        "#{resources_path}/#{id}"
      end

      def from_xml doc
        error_pointer = Pointer.new(:object)
        array_nodes  = doc.nodesForXPath("//#{@array_root}/#{@node_root}", error: error_pointer)
        single_nodes = doc.nodesForXPath("//#{@node_root}", error: error_pointer)
        if array_nodes.length > 0
          return array_nodes.map{ |n| object_from_node(n) }
        elsif single_nodes.length > 0
          return object_from_node(single_nodes.first)
        else
          raise "Unexpected response"
        end
        nil
      end

      def xml_to_key xml
        xml.to_s.gsub("-","_").camelize(false)
      end

      def object_from_node node
        attributes = {}
        node.children.each do |child_node|
          key = xml_to_key(child_node.name)
          if @properties.keys.include?(key.to_sym)
            value = child_node.stringValue
            case @properties[key.to_sym][:type]
            when NSInteger64AttributeType, NSInteger32AttributeType, NSInteger16AttributeType
              value = value.to_i
            when NSBooleanAttributeType
              value = (value == "true")
            when NSDateAttributeType
              date_formatter = NSDateFormatter.alloc.init
              date_formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
              value = date_formatter.dateFromString value
            end
            attributes[key.to_sym] = value
          end
        end
        object = @klass.new(@storage_context.find_or_initialize_instance(@node_root,attributes[:id]))
        object.attributes = attributes
        object
      end

      private

      def import_xml doc
        added_or_updated_objects = from_xml(doc)
        # TODO: We should remove items that where not returned here.
        @storage_context.persist!
      end

    end
  end
end
