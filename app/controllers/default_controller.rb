class DefaultController < UIViewController
  
  attr_accessor :cancelButton
  
  def loadView
    if self.view
      self.view.controller = self
      self.view.setNeedsDisplay
    end
  end
  
  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:animated)

    @cancelButton = GUI.squareCancelBarButtonWithTarget self, action:"clickedCancelButton"
    self.navigationItem.leftBarButtonItem = @cancelButton

    self.navigationItem.titleView = UIImageView.alloc.initWithImage UIImage.imageNamed("navigationbar_title.png")
    
    Notification.subscribe UIKeyboardDidHideNotification, action:"keyboardHide", observer:self
    Notification.subscribe UIKeyboardDidShowNotification, action:"keyboardShow", observer:self
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