class RegisterController < PopupController

  attr_accessor :doneButton

  stylesheet :registerView

  layout do
    self.view = layout(RegisterView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @doneButton = GUI.squareBarButtonWithTitle _("Continue"), target:self, action:"registerPerson"
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

  def registerPerson
    self.view.dismissKeyboard

    newPerson               = Caren::Person.new
    newPerson.email         = fieldMapping[:email].text
    newPerson.firstName     = fieldMapping[:firstName].text
    newPerson.lastName      = fieldMapping[:lastName].text
    newPerson.password      = fieldMapping[:password].text
    newPerson.male          = fieldMapping[:male].text == _("Male")
    newPerson.receivesCare  = fieldMapping[:receivesCare].on?
    newPerson.linkProtocol  = "caren"

    setLoading(true)
    Caren::Person.remote.create(caren, newPerson) do |person, context, errors|
      setLoading(false)
      if errors
        alert _("Could not sign you up"), errors.join("\n")
      else
        context.persist!
        # Temporarily store the credentials until we can convert them to a token.
        # These do not work until the account is activated, so securing them is not critical.
        App::Persistence['username'] = fieldMapping[:email].text
        App::Persistence['password'] = fieldMapping[:password].text
        navigationController.pushViewController( CheckInboxController.alloc.init, animated: true)
      end
    end
  end

  def self.activatePerson id, code
    setLoading(true)
    Caren::Person.remote.activate(caren,id,code) do |person, context, errors|
      if errors
        setLoading(false)
        case errors.first.message
        when "PersonAlreadyActivated"
          activatedAndManualSignIn
        else
          alert _("Could not activate account"), errors.join("\n")
        end
      else
        context.persist!

        if App::Persistence['username'] && App::Persistence['password']
          caren.getAccessTokenForUsername(App::Persistence['username'], andPassword: App::Persistence['password']) do |token, error|
            setLoading(false)
            if error
              activatedAndManualSignIn
            else
              GUI.hideController(App.delegate.navigationController.presentedViewController, false)
              # TODO: Show actual app UI
            end
          end
        else
          setLoading(false)
          activatedAndManualSignIn
        end

        # If activation succeeded we clear the persistant data whatever happens.
        App::Persistence['username'] = nil
        App::Persistence['password'] = nil
      end
    end
  end

  def self.activatedAndManualSignIn
    alert _("Account activated"), _("Awesome! Your account has been activated. Please log in to continue!")
    GUI.showController SignInController.alloc.init, true
  end

end