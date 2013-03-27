module Caren
  class Api

    SITE      = "caren-cares.com"
    KEY       = "o2HHwSflL8myngwy8yv3fGNfLSAPmpx6I4Bc0N0w"
    SECRET    = "eDeXOI0l79YhXiO3BFe8eHZxLDuXFsANDjG9iMI6"

    attr_accessor :keychain, :httpClient

    def initialize keychain_identifier, database
      @keychain = KeychainItemWrapper.alloc.initWithIdentifier keychain_identifier, accessGroup: nil

      @httpClient = AFXAuthClient.alloc.initWithBaseURL NSURL.URLWithString("https://#{SITE}"),
                                                         key: KEY,
                                                         secret: SECRET

      setAccessToken if hasCredentials?
    end

    def getAccessTokenForUsername username, andPassword: password
      @httpClient.authorizeUsingXAuthWithAccessTokenPath "/oauth/access_token",
                                                          accessMethod: "POST",
                                                          username: username,
                                                          password: password,
                                                          success: (lambda do |token|
                                                                      Notification.post "GetAccessTokenSucceeded"
                                                                      setAndStoreAccessToken(token)
                                                                   end),
                                                          failure: lambda{ |error| Notification.post "GetAccessTokenFailed", error }
    end

    def self.availableClasses
      [Caren::Person]
    end

    def import
      self.class.availableClasses.each{ |k| k.remote.import(self) }
    end

    def hasCredentials?
      accessTokenKey.present? && accessTokenSecret.present?
    end

    def get path, parameters, success, failure
      httpMethod "GET", path, parameters, success, failure
    end

    def post path, parameters, success, failure
      httpMethod "POST", path, parameters, success, failure
    end

    def put path, parameters, success, failure
      httpMethod "PUT", path, parameters, success, failure
    end

    def delete path, parameters, success, failure
      httpMethod "DELETE", path, parameters, success, failure
    end

    private

    def httpMethod method, path, parameters, success, failure
      request = @httpClient.requestWithMethod(method, path: path, parameters: parameters)
      operation = ::AFKissXMLRequestOperation.XMLDocumentRequestOperationWithRequest request, success: success, failure: failure
      httpClient.enqueueHTTPRequestOperation(operation)
    end

    def setAccessToken
      @httpClient.token = accessToken
    end

    def setAndStoreAccessToken token
      @keychain.setObject token.key, forKey: KSecAttrAccount
      @keychain.setObject token.secret, forKey: KSecValueData
      setAccessToken
    end

    def accessTokenKey
      @keychain.objectForKey(KSecAttrAccount)
    end

    def accessTokenSecret
      @keychain.objectForKey(KSecValueData)
    end

    def accessToken
      AFXAuthToken.alloc.initWithKey accessTokenKey, secret: accessTokenSecret
    end

  end
end
