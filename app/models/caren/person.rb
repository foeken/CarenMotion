module Caren
  class Person < Base

    key :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword
    key :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me
    key :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled
    key :messageNotificationsViaEmailEnabled, :messageNotificationsViaPhoneEnabled
    key :createdAt, :updatedAt

    def self.find id, session
      session.get resource_path(id), nil, lambda{ |request,response,doc| puts Caren::Person.from_xml(doc).email }, lambda{ |request,response,error,doc| puts doc }
    end

    # def create session
    #   session.post "/api/people.xml", nil, lambda{ |request,response,doc| puts doc }, lambda{ |request,response,error,doc| puts doc }
    # end

    def self.array_root
      :people
    end

    def self.node_root
      :person
    end

  end
end
