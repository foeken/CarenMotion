module Caren
  class XAuth

    attr_accessor :connection, :data

    def self.requestForUsername username, andPassword: password
      GCOAuth.URLRequestForPath "/oauth/access_token",
                                POSTParameters: { "x_auth_username" => username,
                                                  "x_auth_password" => password,
                                                  "x_auth_mode" => "client_auth" },
                                scheme:"https",
                                host:Caren::Api::SITE,
                                consumerKey:Caren::Api::KEY,
                                consumerSecret:Caren::Api::SECRET,
                                accessToken:nil,
                                tokenSecret:nil
    end

    def initializeWithUsername username, andPassword: password
      xauthRequest = self.class.requestForUsername username, andPassword: password
      @connection = NSURLConnection.alloc.initWithRequest xauthRequest, delegate:self
    end

    # NSURLConnection delegate methods

    def connection(connection, didReceiveResponse:response)
      @data = NSMutableData.alloc.init
    end

    def connection(connection, didReceiveData:data)
      @data.appendData(data)
    end

    def connectionDidFinishLoading(connection)
      body = NSString.alloc.initWithData @data, encoding:NSUTF8StringEncoding
      Notification.post "XAuthSucceeded", Hash[body.split('&').map{ |x| x.split('=') }]
    end

    def connection(connection, didFailWithError:error)
      puts error.localizedDescription
      Notification.post "XAuthFailed"
    end

  end
end