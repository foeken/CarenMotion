module Caren
  class Person < Base

    def self.keys
      [ :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword,
        :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me,
        :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled,
        :messageNotificationsViaEmailEnabled, :messageNotificationsViaphoneEnabled
      ] + super
    end

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
end