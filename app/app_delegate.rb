class AppDelegate

  attr_accessor :navigationController, :caren

  include AppDelegate::ConnectionCheck
  include AppDelegate::Keyboard

  def application(application, didFinishLaunchingWithOptions:launchOptions)

    setupConnectionCheck
    setupKeyboard

    @caren = Caren::Api.new( "CarenAccessTokenAndSecret", "caren.sqlite" )

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = self.navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def navigationController
    if @caren.accessTokenAndSecretAvailable?
      # We should show the actual APP controller here
      @navigationController ||= UINavigationController.alloc.initWithRootViewController( SplashController.alloc.init )
    else
      @navigationController ||= UINavigationController.alloc.initWithRootViewController( SplashController.alloc.init )
    end
  end

end