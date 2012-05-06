class SignInController < DefaultController

  attr_accessor :signInButton

  def loadView
    self.view = SignInView.alloc.init
    super
  end

  def viewWillAppear(animated)
    @signInButton = GUI.squareBarButtonWithTitle _("Sign in"), target:self, action:"clickedSignInButton"
    self.navigationItem.rightBarButtonItem = @signInButton
    super
  end

  def clickedSignInButton
    self.view.dismissKeyboard
    # TODO: Handle sign in
  end

end