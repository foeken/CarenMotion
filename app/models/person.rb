class Person < Caren::Base

  key :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword
  key :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me
  key :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled
  key :messageNotificationsViaEmailEnabled, :messageNotificationsViaphoneEnabled

  def self.all session
    session.manager.loadObjectsAtResourcePath resourceUrl, delegate:self
  end

  def self.find session, id
    session.manager.loadObjectsAtResourcePath resourceUrl(id), delegate:self
  end

  def self.resourceLocation
    "/api/people"
  end

  def self.rootKeyPath
    "people.person"
  end

end