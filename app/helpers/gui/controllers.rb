class GUI

  def self.hideController controller, animated=true
    controller.dismissModalViewControllerAnimated(animated) if controller
  end

  def self.showController controller, force=false
    GUI.hideController(App.delegate.navigationController.presentedViewController, false) if force
    GUI.showController(controller, modalTransitionStyle:UIModalTransitionStyleCoverVertical)
  end

  def self.showController controller, modalTransitionStyle:modalTransitionStyle
    navigation = UINavigationController.alloc.initWithRootViewController( controller )
    navigation.modalTransitionStyle = modalTransitionStyle
    GUI.customizeNavigationController(navigation, backgroundImage:"navigationbar_background.png")
    appDelegate.navigationController.presentViewController(navigation, animated:true, completion: nil)
  end

end