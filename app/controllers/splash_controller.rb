class SplashController < UIViewController

  def loadView
    self.view = SplashView.alloc.init
    self.view.controller = self
    self.view.setNeedsDisplay
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:animated)
    if appDelegate.caren.accessTokenAndSecretAvailable?
      # Show the actual UI
      puts "We should be showing application UI!"
    end
  end

end