class SignInController < PopupController

  attr_accessor :signInButton

  stylesheet :signInView

  layout do
    self.view = layout(SignInView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @signInButton = GUI.squareBarButtonWithTitle _("Sign in"), target:self, action:"signIn"
    self.navigationItem.rightBarButtonItem = @signInButton
    self.navigationItem.titleView = UIImageView.alloc.initWithImage "navigationbar_title.png".uiimage
    super
  end

  def signInPossible?
    !self.view.emailTextField.text.nil? && !self.view.passwordTextField.text.nil?
  end

  def forgotPassword email
    Caren::Person.remote.forgotPassword(caren, email) do |person, context, errors|
      if errors
        alert _("Could not reset password"), errors.join("\n")
      else
        # TODO: Do it properly and hook into the link-protocol API to handle resetting the password internally. (also broken in original app)
        alert _("Password reset mail sent"), _("We sent you an email with reset instructions.")
      end
    end
  end

  def signIn
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