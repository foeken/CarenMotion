module Caren
  class Base

    attr_accessor :attributes

    def initialize args={}
      self.attributes = {}
      self.class.keys.each do |key|
        if args.has_key?(key)
          self.attributes[key] = args[key]
        elsif args.has_key?(key.to_s)
          self.attributes[key] = args[key.to_s]
        else
          self.attributes[key] = nil
        end
      end
    end

    def self.keys
      [:createdAt, :updatedAt]
    end

    def self.resourceUrl id=nil
      [self.resourceLocation,id].compact.join("/") + ".xml"
    end

    def self.objectLoader objectLoader, didLoadObjects:objects
      p "SUCCESS"
      p objects
      objects
    end

    def self.objectLoader objectLoader, didFailWithError:error
      p "FAIL"
      p error.localizedDescription
      p NSString.alloc.initWithData(objectLoader.response.body, encoding:NSUTF8StringEncoding)
    end

    def self.register session
      session.manager.mappingProvider.setMapping(mapping, forKeyPath:rootKeyPath)
    end

    def self.mapping
      objectMapping = RKObjectMapping.mappingForClass(self)
      keys.each do |key|
        objectMapping.mapKeyPath key.to_s.underscore.gsub("_","-"), toAttribute:key.to_s
      end
      objectMapping.ignoreUnknownKeyPaths = true
      objectMapping.rootKeyPath = rootKeyPath
      return objectMapping
    end

  end
end