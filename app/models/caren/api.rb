module Caren
  class Api

    KEYCHAIN  = "CarenAccessTokenAndSecret"
    SITE      = "caren-cares.com"
    KEY       = "o2HHwSflL8myngwy8yv3fGNfLSAPmpx6I4Bc0N0w"
    SECRET    = "eDeXOI0l79YhXiO3BFe8eHZxLDuXFsANDjG9iMI6"

    attr_accessor :manager, :keychain

    def initialize
      #RKParserRegistry.sharedRegistry.setParserClass RKXMLParserLibXML, forMIMEType:"application/xml"

      @manager = RKObjectManager.objectManagerWithBaseURL(NSURL.alloc.initWithString("https://#{SITE}"))
      @manager.client.OAuth1ConsumerKey = KEY
      @manager.client.OAuth1ConsumerSecret = SECRET
      @manager.client.authenticationType = RKRequestAuthenticationTypeOAuth1
      @manager.acceptMIMEType = RKMIMETypeXML
      @manager.serializationMIMEType = RKMIMETypeXML

      @keychain = KeychainItemWrapper.alloc.initWithIdentifier KEYCHAIN, accessGroup: nil
      setAccessTokenAndSecret

      Person.register(self)
    end

    def accessTokenAndSecretAvailable?
      @manager.client.OAuth1AccessToken && @manager.client.OAuth1AccessTokenSecret
    end

    def setAccessTokenAndSecret
      @manager.client.OAuth1AccessToken = @keychain.objectForKey KSecAttrAccount
      @manager.client.OAuth1AccessTokenSecret = @keychain.objectForKey KSecValueData
    end

    def getAccessTokenForUsername username, andPassword: password
      subscribe "XAuthFailed", "getAccessTokenFailed:"
      subscribe "XAuthSucceeded", "storeAndSetAccessTokenAndSecret:"
      Caren::XAuth.alloc.initializeWithUsername username, andPassword: password
    end

    def getAccessTokenFailed notification
      unsubscribe "XAuthFailed"
      unsubscribe "XAuthSucceeded"
      Notification.post "GetAccessTokenFailed", notification.object
    end

    def storeAndSetAccessTokenAndSecret notification
      @keychain.setObject notification.object["oauth_token"], forKey: KSecAttrAccount
      @keychain.setObject notification.object["oauth_token_secret"], forKey: KSecValueData
      setAccessTokenAndSecret
      unsubscribe "XAuthFailed"
      unsubscribe "XAuthSucceeded"
      Notification.post "GetAccessTokenSucceeded"
    end

  end
end