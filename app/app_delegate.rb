class AppDelegate

  attr_accessor :navigationController, :caren

  include AppDelegate::ConnectionCheck
  include AppDelegate::Keyboard

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    setupConnectionCheck
    setupKeyboard

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = self.navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def application application, handleOpenURL:url
    if attrs = url.absoluteString.match(/caren:\/\/people\/(.*)\/activate\/(.*)/).captures
      RegisterController.activatePerson(attrs.first,attrs.last)
    end
  end

  def caren
    @caren ||= Caren::Api.new( "CarenAccessTokenAndSecret", "caren.sqlite" )
  end

  def navigationController
    if caren.hasCredentials?
      # We should show the actual APP controller here
      @navigationController ||= UINavigationController.alloc.initWithRootViewController( SplashController.alloc.init )
    else
      @navigationController ||= UINavigationController.alloc.initWithRootViewController( SplashController.alloc.init )
    end
  end

end