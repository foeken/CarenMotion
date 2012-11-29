class Person < Caren::Base

  key :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword
  key :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me
  key :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled
  key :messageNotificationsViaEmailEnabled, :messageNotificationsViaphoneEnabled
  key :createdAt, :updatedAt

  def self.sync session
    session.manager.loadObjectsAtResourcePath resourceUrl, delegate:self
  end

  def create session
    session.manager.postObject self, delegate: self
  end

  def update session
    session.manager.putObject self, delegate: self
  end

  def destroy session
    session.manager.deleteObject self, delegate: self
  end

  def self.all session
    request = NSFetchRequest.alloc.init
    request.entity = self.entity

    error_ptr = Pointer.new(:object)
    data = session.context.executeFetchRequest(request, error:error_ptr)
    if data == nil
      raise "Error when fetching data: #{error_ptr[0].description}"
    end
    data
  end

  def self.resourceLocation
    "/api/people"
  end

  def self.entityClass
    # We need this because CoreData objects have a different
    # but related class that is missing some of the meta stuff
    Person
  end

  def self.collectionName
    "people"
  end

  def self.nodeName
    "person"
  end

end