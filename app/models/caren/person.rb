module Caren
  class Person < Base

    key :id, :ownerId, :firstName, :lastName, :male, :password, :newPassword, :oldPassword
    key :email, :dateOfBirth, :photo, :bio, :note, :timeZone, :account, :linkProtocol, :me
    key :receivesCare, :eventRemindersViaEmailEnabled, :eventRemindersViaPhoneEnabled
    key :messageNotificationsViaEmailEnabled, :messageNotificationsViaphoneEnabled
    key :createdAt, :updatedAt

  end
end