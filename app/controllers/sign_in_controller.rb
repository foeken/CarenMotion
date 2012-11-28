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
    caren.getAccessTokenForUsername self.view.emailTextField.text, andPassword: self.view.passwordTextField.text
    # Set loading state
    # Setup subscription so the loading state is removed and we log in
  end

end