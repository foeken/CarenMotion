class RegisterController < PopupController

  attr_accessor :doneButton

  stylesheet :registerView

  layout do
    self.view = layout(RegisterView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @doneButton = GUI.squareBarButtonWithTitle _("Done"), target:self, action:"clickedDoneButton"
    self.navigationItem.rightBarButtonItem = @doneButton
    super
  end

  def clickedDoneButton
    self.view.dismissKeyboard

    newPerson               = Caren::Person.new
    newPerson.email         = view.emailTextField.text
    newPerson.firstName     = view.firstNameTextField.text
    newPerson.lastName      = view.lastNameTextField.text
    newPerson.password      = view.passwordTextField.text
    newPerson.male          = (view.genderLabel.text == _("Male"))
    newPerson.receivesCare  = view.receivesCareSwitch.on?
    newPerson.linkProtocol  = "caren://"

    Caren::Person.remote.create(caren, newPerson) do |person, context, error|
      if error
        # TODO Handle validations centrally
        NSLog("Error creating account: %@", error)
        alert _("Could not create new account"), _("Fill out all of the fields and try again!")
      else
        context.persist!
        # TODO: Show the waiting for e-mail screen.
      end
    end

  end

end