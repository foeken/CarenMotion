module Caren
  class Base < NSManagedObject

    def initialize args={}
      self.class.keys.each do |key|
        if args.has_key?(key)
          self.send "#{key}=", args[key]
        elsif args.has_key?(key.to_s)
          self.send "#{key}=", args[key.to_s]
        else
          self.send "#{key}=", nil
        end
      end
    end

    def self.key(*vars)
      @keys ||= []
      @keys.concat vars
    end

    key :createdAt, :updatedAt

    def self.keys
      @keys
    end

    def self.resourceUrl id=nil
      [self.resourceLocation,id].compact.join("/") + ".xml"
    end

    def self.objectLoader objectLoader, didLoadObjects:objects
      p objects
    end

    def self.objectLoader objectLoader, didFailWithError:error
      p "FAIL"
      p error.localizedDescription
      p NSString.alloc.initWithData(objectLoader.response.body, encoding:NSUTF8StringEncoding)
    end

    def self.register session
      session.manager.mappingProvider.setMapping(mapping(session), forKeyPath:rootKeyPath)
    end

    def self.entity
      @entity ||= begin
        entity = NSEntityDescription.alloc.init
        entity.name = self.name
        entity.managedObjectClassName = self.name
        entity.properties = keys.map do |key|
          property = NSAttributeDescription.alloc.init
          property.name = key.to_s
          property.attributeType = NSStringAttributeType
          property.optional = true
          property
        end
        entity
    end
  end

    def self.mapping session
      objectMapping = RKManagedObjectMapping.mappingForEntity(self.entity, inManagedObjectStore:session.storage)
      keys.each do |key|
        objectMapping.mapKeyPath key.to_s.underscore.gsub("_","-")+".text", toAttribute:key.to_s
      end
      objectMapping.primaryKeyAttribute = "id"
      objectMapping.ignoreUnknownKeyPaths = false
      objectMapping.rootKeyPath = rootKeyPath
      return objectMapping
    end

  end
end