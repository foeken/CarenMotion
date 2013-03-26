module Caren
  class Base

    def self.key(*vars)
      @keys ||= []
      @keys.concat vars
      attr_accessor *vars
    end

    def self.keys
      @keys
    end

    def self.from_xml doc
      error_pointer = Pointer.new(:object)
      array_nodes  = doc.nodesForXPath("//#{array_root}/#{node_root}", error: error_pointer)
      single_nodes = doc.nodesForXPath("//#{node_root}", error: error_pointer)
      if array_nodes.length > 0
        return array_nodes.map{ |n| object_from_node(n) }
      elsif single_nodes.length > 0
        return object_from_node(single_nodes.first)
      else
        raise "Unexpected response."
      end
      nil
    end

    def self.array_root
      :objects
    end

    def self.node_root
      :object
    end

    def self.resources_path
      "/api/#{array_root}"
    end

    def self.resource_path id
      "#{resources_path}/#{id}"
    end

    def self.xml_to_key xml
      xml.to_s.gsub("-","_").camelize(false)
    end

    def self.object_from_node node
      self.new.tap do |object|
        node.children.each do |child_node|
          object.send("#{xml_to_key(child_node.name)}=",child_node.stringValue) rescue nil
        end
      end
    end

  end
end
