module Caren
  class Api

    KEY       = "o2HHwSflL8myngwy8yv3fGNfLSAPmpx6I4Bc0N0w"
    SECRET    = "eDeXOI0l79YhXiO3BFe8eHZxLDuXFsANDjG9iMI6"

    attr_accessor :keychain, :httpClient

    def site
      case @locale
      when :en
        "caren-cares.com"
      when :nl
        "carenzorgt.nl"
      end
    end

    def initialize keychain_identifier, database, locale=:en
      @locale = locale
      @keychain = KeychainItemWrapper.alloc.initWithIdentifier keychain_identifier, accessGroup: nil

      @httpClient = AFXAuthClient.alloc.initWithBaseURL NSURL.URLWithString("https://#{site}"),
                                                         key: KEY,
                                                         secret: SECRET

      setAccessToken if hasCredentials?
    end

    def getAccessTokenForUsername username, andPassword: password, &block
      @httpClient.authorizeUsingXAuthWithAccessTokenPath "/oauth/access_token",
                                                          accessMethod: "POST",
                                                          username: username,
                                                          password: password,
                                                          success: lambda { |token| setAndStoreAccessToken(token) ; block.call(token, nil) },
                                                          failure: lambda { |error| block.call(nil, error) }
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

    def get path, success, failure
      httpMethod "GET", path, nil, success, failure
    end

    def post path, body, success, failure
      httpMethod "POST", path, body, success, failure
    end

    def put path, body, success, failure
      httpMethod "PUT", path, body, success, failure
    end

    def delete path, success, failure
      httpMethod "DELETE", path, nil, success, failure
    end

    private

    def httpMethod method, path, body, success, failure
      request = @httpClient.requestWithMethod(method, path: path, parameters: nil)
      request.HTTPBody = body
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
