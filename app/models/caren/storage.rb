module Caren
  class Storage

    def self.shared
      @storage ||= Caren::Storage.new
    end

    def build_instance name, attributes={}
      NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext:context).tap do |instance|
        attributes.each do |key,value|
          instance.send("#{key}=",value)
        end
      end
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
      entity = stored_classes[name].entity
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

    def stored_classes
      {:person => Caren::Person}
    end

    def entity_model
      NSManagedObjectModel.new.tap do |model|
        model.entities = stored_classes.values.map(&:entity)
      end
    end

    def path
      NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', "caren.sqlite"))
    end

    def store
      @store ||= begin
        error_ptr = Pointer.new(:object)
        NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(entity_model).tap do |store|
          unless store.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:path, options:nil, error:error_ptr)
            raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
          end
        end
      end
    end

    def context
      @context ||= NSManagedObjectContext.new.tap do |context|
        context.persistentStoreCoordinator = store
      end
    end

    def persist!
      error_ptr = Pointer.new(:object)
      raise "Error when saving the model: #{error_ptr[0].description}" unless context.save(error_ptr)
    end

  end
end
