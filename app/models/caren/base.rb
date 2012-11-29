module Caren
  class Base < NSManagedObject

    def self.key(*vars)
      @keys ||= []
      @keys.concat vars
    end

    def self.keys
      @keys
    end

    def self.resourceUrl id=nil
      [self.resourceLocation,id].compact.join("/") + ".xml"
    end

    def self.rootKeyPath
      [self.collectionName,self.nodeName].join('.')
    end

    def self.objectLoader objectLoader, didLoadObjects:objects
      p objects
    end

    def self.objectLoader objectLoader, didFailWithError:error
      alert _("Oops..."), _("Something went wrong, please try again later")
    end

    def objectLoader objectLoader, didFailWithError:error
      puts error.localizedDescription
      alert _("Oops..."), _("Something went wrong, please try again later")
    end

    def self.register session
      session.manager.mappingProvider.setMapping(mapping(session), forKeyPath:rootKeyPath)
      session.manager.mappingProvider.setSerializationMapping(inverseMapping(session), forClass:self)
      session.manager.router.routeClass self, toResourcePath:"#{resourceLocation}/:id"
      session.manager.router.routeClass self, toResourcePath:resourceLocation, forMethod: RKRequestMethodPOST
    end

    def self.entity
      @entity ||= begin
        entity = NSEntityDescription.alloc.init
        entity.name = entityClass.name
        entity.managedObjectClassName = entityClass.name
        entity.properties = entityClass.keys.map do |key|
          property = NSAttributeDescription.alloc.init
          property.name = key.to_s
          property.attributeType = NSStringAttributeType
          property.optional = true
          property
        end
        entity
    end
  end

  def serialize session
    inverseMapping = self.class.inverseMapping(session)
    RKObjectSerializer.alloc.initWithObject(self, mapping:inverseMapping).serializedObject(Pointer.new(:object))
  end

  def self.inverseMapping session
    @inverseObjectMapping ||= begin
      objectMapping = RKManagedObjectMapping.mappingForEntityWithName(entityClass.name, inManagedObjectStore:session.storage)
      entityClass.keys.each do |key|
        objectMapping.mapKeyPath key.to_s, toAttribute:key.to_s.underscore.gsub("_","-")
      end
      objectMapping.rootKeyPath = nodeName
      objectMapping
    end
  end

  def self.mapping session
    @objectMapping ||= begin
      objectMapping = RKManagedObjectMapping.mappingForEntityWithName(entityClass.name, inManagedObjectStore:session.storage)
      entityClass.keys.each do |key|
        objectMapping.mapKeyPath key.to_s.underscore.gsub("_","-")+".text", toAttribute:key.to_s
      end
      objectMapping.primaryKeyAttribute = "id"
      objectMapping.ignoreUnknownKeyPaths = false
      objectMapping.rootKeyPath = nodeName
      objectMapping
    end
  end

  end
end