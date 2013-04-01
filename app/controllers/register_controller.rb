class RegisterController < PopupController

  attr_accessor :doneButton

  stylesheet :registerView

  layout do
    self.view = layout(RegisterView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @doneButton = GUI.squareBarButtonWithTitle _("Continue"), target:self, action:"clickedDoneButton"
    self.navigationItem.rightBarButtonItem = @doneButton
    self.title = _("Register")
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

    setLoading(true)
    Caren::Person.remote.create(caren, newPerson) do |person, context, errors|
      setLoading(false)
      if errors
        alert _("Could not sign you up"), errors.join("\n")
        # TODO: Remove this test
        navigationController.pushViewController( CheckInboxController.alloc.init, animated: true)
      else
        context.persist!
        navigationController.pushViewController( CheckInboxController.alloc.init, animated: true)
      end
    end

  end

end