class RegisterController < DefaultController

  attr_accessor :doneButton

  def loadView
    self.view = RegisterView.alloc.init
    super
  end

  def viewWillAppear(animated)
    @doneButton = GUI.squareBarButtonWithTitle _("Done"), target:self, action:"clickedDoneButton"
    self.navigationItem.rightBarButtonItem = @doneButton
    super
  end

  def clickedDoneButton
    self.view.dismissKeyboard
    # TODO: Handle New registration
  end

end