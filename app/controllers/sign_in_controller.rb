class SignInController < UIViewController

  def loadView
    self.view = SignInView.alloc.init
    self.view.setNeedsDisplay
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:animated)

    cancel = GUI.squareBarButtonItemWithTitle _("Cancel"),
                                              backgroundImage:"navigationbar_button_normal.png",
                                              backgroundImageTapped:"navigationbar_button_light.png",
                                              target:self,
                                              action:"clickedCancelButton"

    signIn = GUI.squareBarButtonItemWithTitle _("Sign in"),
                                              backgroundImage:"navigationbar_button_light.png",
                                              backgroundImageTapped:"navigationbar_button_normal.png",
                                              target:self,
                                              action:"clickedSignInButton"

    self.navigationItem.titleView = UIImageView.alloc.initWithImage UIImage.imageNamed("navigationbar_title.png")
    self.navigationItem.leftBarButtonItem = cancel
    self.navigationItem.rightBarButtonItem = signIn
  end

  def clickedSignInButton
  end

  def clickedCancelButton
    self.dismissModalViewControllerAnimated(true)
  end

end