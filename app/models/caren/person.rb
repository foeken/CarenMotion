module Caren
  class Person < Base

    property :id, ::NSInteger64AttributeType, :required => true
    property :ownerId, ::NSInteger64AttributeType
    property :firstName, ::NSStringAttributeType
    property :lastName, ::NSStringAttributeType
    property :male, ::NSBooleanAttributeType

    property :email, ::NSStringAttributeType
    property :account, ::NSBooleanAttributeType
    property :me, ::NSBooleanAttributeType
    property :receivesCare, ::NSBooleanAttributeType

    property :dateOfBirth, ::NSDateAttributeType
    property :photo, ::NSStringAttributeType
    property :timeZone, ::NSStringAttributeType

    property :bio, ::NSStringAttributeType
    property :note, ::NSStringAttributeType

    property :eventRemindersViaEmailEnabled, ::NSBooleanAttributeType
    property :eventRemindersViaPhoneEnabled, ::NSBooleanAttributeType
    property :messageNotificationsViaEmailEnabled, ::NSBooleanAttributeType
    property :messageNotificationsViaPhoneEnabled, ::NSBooleanAttributeType

    property :createdAt, ::NSDateAttributeType
    property :updatedAt, ::NSDateAttributeType

    # Non tracked fields
    property :password
    property :newPassword
    property :oldPassword
    property :linkProtocol

    def self.array_root
      :people
    end

    def self.node_root
      :person
    end

  end
end
