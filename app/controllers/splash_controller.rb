class SplashController < UIViewController

  def loadView
    self.view = SplashView.alloc.init
    self.view.controller = self
    self.view.setNeedsDisplay
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:animated)
    if appDelegate.caren.hasCredentials?
      # Show the actual UI
      puts "YEah baby! Login tokens available. We should be showing application UI!"
      Caren::Person.remote.import(appDelegate.caren)
    end
  end

end