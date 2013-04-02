class SplashController < ApplicationController

  stylesheet :splashView

  layout do
    self.view = layout(SplashView, :root, controller: self)
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(true, animated:animated)
    super
  end

  def showRegister
    if appDelegate.connectionActive
      GUI.showController RegisterController.alloc.init
    else
      alert _("No internet connection"), _("You can't do this without an internet connection.")
    end
  end

  def showSignIn
    if appDelegate.connectionActive
      GUI.showController SignInController.alloc.init
    else
      alert _("No internet connection"), _("You can't do this without an internet connection.")
    end
  end

end