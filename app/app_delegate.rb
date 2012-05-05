class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setupRestKit
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    messages = MessagesController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(messages)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
  
  def setupRestKit
    # Setup a shared RestKit client
    # The consumer secret and tokens are for test accounts. Feel free to use them.
    RKObjectManager.objectManagerWithBaseURL(NSURL.alloc.initWithString("https://www.caren-cares.com/api"))
    RKObjectManager.sharedManager.client.OAuth1ConsumerKey = "qqc93LgeQrEoqbL3H6XvI0ukHJH3fcDlHBa7XEZk"
    RKObjectManager.sharedManager.client.OAuth1ConsumerSecret = "qpjiGggZhNnHGcYN0vQjIbyR0ZitQu4bTu9GUUpM"
    RKObjectManager.sharedManager.client.OAuth1AccessToken = "UCJrZ1D9kACq5s4GM6FZda123thNkqYFmc6SlgJN"
    RKObjectManager.sharedManager.client.OAuth1AccessTokenSecret = "Qk0CUZkPUeP8dhBSTdHZRX9Xj7tg22Fzymn0C2mr"
    
    
    # ISSUE: It seems to fail recognizing the defined constants
    RKObjectManager.sharedManager.client.authenticationType = 3 # RKRequestAuthenticationTypeOAuth1    
    RKObjectManager.sharedManager.acceptMIMEType = "application/xml" # RKMIMETypeXML
    RKObjectManager.sharedManager.serializationMIMEType = "application/xml" # RKMIMETypeXML
    
    # ISSUE: Calling this method from the code fails, from the console it works. The code version yields an error saying it cannot find the precompiled version of this method. Seems to have something to do when I use a Ruby class instead of a default pure NS class. (methods with strings, NSObject, etc work, with CareProvider they don't)
    # CareProvider.register
    
    # ISSUE: Calling CareProvider.all works from the console before the mapping is registered. If you call it after a CareProvider.register it crashes the app with no vsisible exception message.
    
  end
  
end
