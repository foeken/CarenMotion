module Caren
  class Base

    # New objects are found and created in this context by default
    def self.storage_context
      @storage_context ||= Caren::StorageContext.shared
    end

    def self.remote
      @remote ||= Caren::Remote::Proxy.new(self, array_root, node_root, properties)
    end

    def toXml
      Caren::Remote::Proxy.serialize(self)
    end

    # Properties are routed to the managed_instance or set to an instance variable when there is no instance
    # or if the instance is not tracking those fields.
    def self.property(name, type=nil, options={})
      @properties ||= {}
      @properties[name] = options.merge(:type => type)
      if type
        define_method "#{name}"  do
          managed_instance ? managed_instance.send("#{name}") : instance_variable_get("@#{name}")
        end
        define_method "#{name}=" do |args|
          managed_instance ? managed_instance.send("#{name}=", args) : instance_variable_set("@#{name}", args)
        end
      else
        attr_accessor(name)
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

    def initialize(instance=nil)
      @managed_instance = instance
      super()
    end

    def managed_instance
      @managed_instance
    end

    def destroy
      managed_instance ? !!self.class.storage_context.delete_instance(managed_instance) : false
    end

    def self.find id
      if instance = storage_context.find_instance(self.node_root, id)
        new instance
      else
        nil
      end
    end

    def self.where conditions, *args
      predicate = NSPredicate.predicateWithFormat(conditions, argumentArray:args)
      self.storage_context.where(self.node_root,predicate).map{ |i| new(i) }
    end

    def ==(other)
      id == other.id && other.is_a?(self.class)
    end

    def eql?(other)
      self == other
    end

    def hash
      "#{self.class.name}-#{id.to_s}".hash
    end

    def self.all limit=nil, offset=nil
      storage_context.all(self.node_root,limit, offset).map{ |i| new(i) }
    end

    def self.find_or_initialize id
      new storage_context.find_or_initialize_instance(self.node_root, id)
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
            property.default = options[:default] if options[:default]
            property.transient = options[:transient] if options[:transient]
            property.indexed = options[:indexed] if options[:indexed]
            property
          end.compact
        end
      end
    end

  end
end
