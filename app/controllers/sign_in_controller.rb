class SignInController < UIViewController

  attr_accessor :cancelButton, :signInButton

  def loadView
    self.view = SignInView.alloc.init
    self.view.controller = self
    self.view.setNeedsDisplay    
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:animated)

    @cancelButton = GUI.squareBarButtonItemWithTitle _("Cancel"),
                                                     backgroundImage:"navigationbar_button_normal.png",
                                                     backgroundImageTapped:"navigationbar_button_light.png",
                                                     target:self,
                                                     action:"clickedCancelButton"

    @signInButton = GUI.squareBarButtonItemWithTitle _("Sign in"),
                                                     backgroundImage:"navigationbar_button_light.png",
                                                     backgroundImageTapped:"navigationbar_button_normal.png",
                                                     target:self,
                                                     action:"clickedSignInButton"

    self.navigationItem.titleView = UIImageView.alloc.initWithImage UIImage.imageNamed("navigationbar_title.png")
    self.navigationItem.leftBarButtonItem = @cancelButton
    self.navigationItem.rightBarButtonItem = @signInButton
    
    Notification.subscribe UIKeyboardDidHideNotification, action:"keyboardHide", observer:self
    Notification.subscribe UIKeyboardDidShowNotification, action:"keyboardShow", observer:self
  end
  
  def keyboardHide
    self.navigationItem.leftBarButtonItem = @cancelButton
  end
    
  def keyboardShow
    tmpCancel = GUI.squareBarButtonItemWithTitle _("Cancel"), backgroundImage:"navigationbar_button_normal.png",
                                                              backgroundImageTapped:"navigationbar_button_light.png",
                                                              target:self.view,
                                                              action:"dismissKeyboard"
    
    self.navigationItem.leftBarButtonItem = tmpCancel
  end

  def clickedSignInButton
    self.view.dismissKeyboard
    p "Sign in"
  end

  def clickedCancelButton
    GUI.hideController(self)
  end

end