module Caren
  class Person < Base

    property :id, ::NSInteger64AttributeType, :required => true, :readonly => true
    property :ownerId, ::NSInteger64AttributeType, :readonly => true
    property :firstName, ::NSStringAttributeType
    property :lastName, ::NSStringAttributeType
    property :male, ::NSBooleanAttributeType

    property :email, ::NSStringAttributeType
    property :account, ::NSBooleanAttributeType, :readonly => true
    property :me, ::NSBooleanAttributeType, :readonly => true
    property :receivesCare, ::NSBooleanAttributeType

    property :dateOfBirth, ::NSDateAttributeType
    property :photo, ::NSStringAttributeType, :readonly => true
    property :timeZone, ::NSStringAttributeType

    property :bio, ::NSStringAttributeType
    property :note, ::NSStringAttributeType

    property :eventRemindersViaEmailEnabled, ::NSBooleanAttributeType
    property :eventRemindersViaPhoneEnabled, ::NSBooleanAttributeType
    property :messageNotificationsViaEmailEnabled, ::NSBooleanAttributeType
    property :messageNotificationsViaPhoneEnabled, ::NSBooleanAttributeType

    property :createdAt, ::NSDateAttributeType, :readonly => true
    property :updatedAt, ::NSDateAttributeType, :readonly => true

    # Non tracked fields
    property :password
    property :newPassword
    property :oldPassword
    property :linkProtocol

    def self.remote
      @remote ||= Caren::Remote::Person.new(self, array_root, node_root, properties)
    end

    def self.array_root
      :people
    end

    def self.node_root
      :person
    end

  end
end
