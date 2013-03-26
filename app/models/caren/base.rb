module Caren
  class Base < ::NSManagedObject

    def self.remote
      @remote ||= Caren::Remote::Proxy.new(self, array_root, node_root, properties)
    end

    def self.property(name, type=nil, options={})
      @properties ||= {}
      @properties[name] = options.merge(:type => type)
      if type
        define_method "#{name}"  { managed_instance.send("#{name}") }
        define_method "#{name}=" { |args| managed_instance.send("#{name}=", args) }
      else
        attr_accessor name
      end
    end

    def attributes
      {}.tap do |attributes|
        self.class.properties.keys.each do |key|
          attributes[key] = send(key)
        end
      end
    end

    def attributes= attributes
      attributes.each do |key,value|
        send("#{key}=",value)
      end
    end

    def self.properties
      @properties
    end

    def self.array_root
      :objects
    end

    def self.node_root
      :object
    end

    # CoreData Methods

    def initialize(instance)
      @managed_instance = instance
      super()
    end

    def managed_instance
      @managed_instance #||= Caren::Storage.shared.build_instance(self.class.node_root)
    end

    def destroy
      !!Caren::Storage.shared.delete_instance(managed_instance) if managed_instance
    end

    def self.find id
      new Caren::Storage.shared.find_instance(self.node_root, id)
    end

    def self.find_or_initialize id
      new Caren::Storage.shared.find_or_initialize_instance(self.node_root, id)
    end

    def self.entity
      @entity ||= begin
        ::NSEntityDescription.new.tap do |entity|
          entity.name = self.node_root
          entity.managedObjectClassName = self.name
          entity.properties = properties.map do |key,options|
            next unless options[:type]
            property = ::NSAttributeDescription.new
            property.name = key
            property.attributeType = options[:type]
            property.optional = (options[:required].nil? ? true : !options[:required])
            property
          end.compact
        end
      end
    end

  end
end
