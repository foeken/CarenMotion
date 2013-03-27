class SignInController < PopupController

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

  def signInPossible?
    !self.view.emailTextField.text.nil? && !self.view.passwordTextField.text.nil?
  end

  def clickedSignInButton
    if signInPossible?
      self.view.dismissKeyboard
      caren.getAccessTokenForUsername self.view.emailTextField.text, andPassword: self.view.passwordTextField.text
      setLoading(true)
      subscribe "GetAccessTokenSucceeded", "signInSucceeded:"
      subscribe "GetAccessTokenFailed", "signInFailed:"
    else
      alert _("Oops..."), _("Please fill out both fields to sign in!")
    end
  end

  def signInFailed notification
    setLoading(false)
    unsubscribe "GetAccessTokenSucceeded"
    unsubscribe "GetAccessTokenFailed"
    alert _("Oops..."), _("We cannot log you in using these credentials. Perhaps you made a typo?")
  end

  def signInSucceeded notification
    setLoading(false)
    unsubscribe "GetAccessTokenSucceeded"
    unsubscribe "GetAccessTokenFailed"
    GUI.hideController(self)
  end

end