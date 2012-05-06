class SplashController < UIViewController
  
  def loadView
    self.view = SplashView.alloc.init
    self.view.controller = self
    self.view.setNeedsDisplay
  end
  
  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:animated)
  end
  
end