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

  def fieldMapping
    {
      email: view.emailTextField,
      firstName: view.firstNameTextField,
      lastName: view.lastNameTextField,
      password: view.passwordTextField,
      male: view.genderLabel,
      receivesCare: view.receivesCareSwitch
    }
  end

  def clickedDoneButton
    self.view.dismissKeyboard

    newPerson               = Caren::Person.new
    newPerson.email         = fieldMapping[:email].text
    newPerson.firstName     = fieldMapping[:firstName].text
    newPerson.lastName      = fieldMapping[:lastName].text
    newPerson.password      = fieldMapping[:password].text
    newPerson.male          = fieldMapping[:male].text == _("Male")
    newPerson.receivesCare  = fieldMapping[:receivesCare].on?
    newPerson.linkProtocol  = "caren://"

    Caren::Person.remote.create(caren, newPerson) do |person, context, errors|
      if errors
        alert _("Could not sign you up"), errors.join("\n")
      else
        context.persist!
        # TODO: Show the waiting for e-mail screen.
      end
    end

  end

end