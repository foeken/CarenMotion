class AppDelegate
  
  attr_accessor :navigationController
  
  include AppDelegate::ConnectionCheck
  include AppDelegate::CarenApi
  include AppDelegate::Keyboard
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)    
    setupCarenApi
    setupConnectionCheck
    setupKeyboard
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = self.navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    
    true
  end
  
  def navigationController
    @navigationController ||= UINavigationController.alloc.initWithRootViewController( SplashController.alloc.init )
  end
  
end