class PopupController < ApplicationController

  attr_accessor :cancelButton

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:animated)

    @cancelButton = GUI.squareCancelBarButtonWithTarget self, action:"clickedCancelButton"
    self.navigationItem.leftBarButtonItem = @cancelButton

    Notification.subscribe UIKeyboardDidHideNotification, action:"keyboardHide", observer:self
    Notification.subscribe UIKeyboardDidShowNotification, action:"keyboardShow", observer:self
    super
  end

  def keyboardHide
    self.navigationItem.leftBarButtonItem = @cancelButton
  end

  def keyboardShow
    tmpCancel = GUI.squareCancelBarButtonWithTarget self.view, action:"dismissKeyboard"
    self.navigationItem.leftBarButtonItem = tmpCancel
  end

  def clickedCancelButton
    GUI.hideController(self)
  end

end