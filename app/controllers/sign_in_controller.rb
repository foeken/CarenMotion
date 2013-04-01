class SignInController < PopupController

  attr_accessor :signInButton

  stylesheet :signInView

  layout do
    self.view = layout(SignInView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @signInButton = GUI.squareBarButtonWithTitle _("Sign in"), target:self, action:"clickedSignInButton"
    self.navigationItem.rightBarButtonItem = @signInButton
    self.navigationItem.titleView = UIImageView.alloc.initWithImage "navigationbar_title.png".uiimage
    super
  end

  def signInPossible?
    !self.view.emailTextField.text.nil? && !self.view.passwordTextField.text.nil?
  end

  def clickedSignInButton
    if signInPossible?
      self.view.dismissKeyboard
      setLoading(true)
      caren.getAccessTokenForUsername self.view.emailTextField.text, andPassword: self.view.passwordTextField.text do |token, error|
        setLoading(false)
        if error
          alert _("Oops..."), _("We cannot log you in using these credentials. Perhaps you made a typo?")
        else
          GUI.hideController(self)
        end
      end
    else
      alert _("Oops..."), _("Please fill out both fields to sign in!")
    end
  end

end