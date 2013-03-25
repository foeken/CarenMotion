module Caren
  class Person < Caren::Base

    attr_accessor :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword
    attr_accessor :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me
    attr_accessor :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled
    attr_accessor :messageNotificationsViaEmailEnabled, :messageNotificationsViaphoneEnabled
    attr_accessor :createdAt, :updatedAt

  end
end