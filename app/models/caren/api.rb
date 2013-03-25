module Caren
  class Api

    SITE      = "caren-cares.com"
    KEY       = "o2HHwSflL8myngwy8yv3fGNfLSAPmpx6I4Bc0N0w"
    SECRET    = "eDeXOI0l79YhXiO3BFe8eHZxLDuXFsANDjG9iMI6"

    attr_accessor :keychain

    def initialize keychain_identifier, database
      @keychain = KeychainItemWrapper.alloc.initWithIdentifier keychain_identifier, accessGroup: nil
    end

    def accessTokenAndSecretAvailable?
      false
    end

  end
end
