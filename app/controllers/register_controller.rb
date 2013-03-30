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

    newPerson = Caren::Person.new
    newPerson.email = view.emailTextField
    # ... TODO

    Caren::Person.remote.create caren, newPerson,
                                lambda do |person, context|
                                  # Save the new person locally
                                  context.persist!
                                  # TODO: Show the waiting for e-mail screen.
                                end
  end

end