# We have a single persistent store with multiple contexts (one per thread: shared and api)
module Caren
  class StorageContext

    def self.shared
      @storage ||= Caren::StorageContext.new
    end

    def self.api
      @storage_api ||= Caren::StorageContext.new
    end

    def build_instance name, attributes={}
      NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext:context).tap do |instance|
        attributes.each do |key,value|
          instance.send("#{key}=",value)
        end
      end
    end

    def delete_instance instance
      context.deleteObject(instance)
    end

    def find_instance name, id
      predicate = NSPredicate.predicateWithFormat("id = %@", argumentArray:[id])
      where(name,predicate,1).first
    end

    def find_or_initialize_instance name, id
      find_instance(name,id) || build_instance(name, :id => id)
    end

    def all name, limit=nil, offset=nil
      where(name, nil, limit, offset)
    end

    def where name, predicate=nil, limit=nil, offset=nil
      request = NSFetchRequest.alloc.init
      entity = self.class.stored_classes[name].entity
      request.setEntity entity
      request.setPredicate predicate if predicate
      request.setFetchLimit limit if limit
      request.setFetchOffset offset if offset
      error_ptr = Pointer.new(:object)
      context.executeFetchRequest(request, error:error_ptr)
    end

    def delete instance
      context.deleteObject(instance)
    end

    def context
      @context ||= NSManagedObjectContext.new.tap do |context|
        context.persistentStoreCoordinator = self.class.store
      end
    end

    def reset!
      @context = nil
      context
    end

    def persist!
      error_ptr = Pointer.new(:object)
      raise "Error when saving the model: #{error_ptr[0].description}" unless context.save(error_ptr)
    end

    # The actual persistant storage, can only be defined once.

    def self.stored_classes
      @stored_classes ||= {}.tap do |stored_classes|
        Caren::Api.available_classes.each do |klass|
          stored_classes[klass.node_root] = klass
        end
      end
    end

    def self.entity_model
      @model ||= NSManagedObjectModel.new.tap do |model|
        model.entities = stored_classes.values.map(&:entity)
      end
    end

    def self.store
      @store ||= begin
        error_ptr = Pointer.new(:object)
        path = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', "caren.sqlite"))
        NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(entity_model).tap do |store|
          unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:path, options:nil, error:error_ptr)
            raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
          end
        end
      end
    end

  end
end
