class Notification
  def self.post name, object=nil
    NSNotificationCenter.defaultCenter.postNotificationName(name, object:object)
  end

  def self.subscribe name, action:selector, observer:observer, object:object
    NSNotificationCenter.defaultCenter.addObserver observer,
                                                   selector:selector,
                                                   name:name,
                                                   object:object
  end

  def self.unsubscribe name, observer:observer, sender:sender
    NSNotificationCenter.defaultCenter.removeObserver observer,
                                                      name:name,
                                                      object:sender
  end

  def self.subscribe name, action:selector, observer:observer
    self.subscribe name, action:selector, observer:observer, object:nil
  end

  def self.unsubscribe name, observer:observer
    self.unsubscribe name, observer:observer, sender:nil
  end
end