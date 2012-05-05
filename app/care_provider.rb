class EmptyClass
end

class CareProvider
  
  # attr_accessor :id, :name, :address_line, :website, :email, :telephone
  # attr_accessor :url_shortcut, :time_zone, :logo, :linkable, :lng, :lat
  # attr_accessor :created_at, :updated_at
  
  def self.all
    RKObjectManager.sharedManager.loadObjectsAtResourcePath "/care_providers.xml", delegate:self
  end
  
  def self.find id
    RKObjectManager.sharedManager.loadObjectsAtResourcePath "/care_providers/#{id}.xml", delegate:self
  end
  
  def self.objectLoader objectLoader, didLoadObjects:objects
    p "SUCCESS"
    p objects
    objects
  end
  
  def self.objectLoader objectLoader, didFailWithError:error
    p "FAIL"
    p error
    p NSString.alloc.initWithData(objectLoader.response.body, encoding:NSUTF8StringEncoding)
  end
  
  def self.register
    RKObjectManager.sharedManager.mappingProvider.setMapping(mapping, forKeyPath:"care-providers.care-provider")
  end
  
  def self.mapping
    objectMapping = RKObjectMapping.mappingForClass(CareProvider)
    
    objectMapping.mapKeyPath "id", toAttribute:"id"
    objectMapping.ignoreUnknownKeyPaths = true
    objectMapping.rootKeyPath = "care-providers.care-provider"
    return objectMapping
  end
  
end