class PopupController < ApplicationController

  attr_accessor :cancelButton

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:animated)

    @cancelButton = GUI.squareCancelBarButtonWithTarget self, action:"clickedCancelButton"
    self.navigationItem.leftBarButtonItem = @cancelButton
    super
  end

  def clickedCancelButton
    GUI.hideController(self)
  end

end