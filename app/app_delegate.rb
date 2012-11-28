class AppDelegate

  attr_accessor :navigationController, :caren

  include AppDelegate::ConnectionCheck
  include AppDelegate::Keyboard

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @caren = Caren::Api.new

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