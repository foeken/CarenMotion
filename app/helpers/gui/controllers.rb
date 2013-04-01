class GUI

  def self.hideController controller
    controller.dismissModalViewControllerAnimated(true)
  end

  def self.showController controller
    GUI.showController(controller, modalTransitionStyle:UIModalTransitionStyleCoverVertical)
  end

  def self.showController controller, modalTransitionStyle:modalTransitionStyle
    navigation = UINavigationController.alloc.initWithRootViewController( controller )
    navigation.modalTransitionStyle = modalTransitionStyle
    GUI.customizeNavigationController(navigation, backgroundImage:"navigationbar_background.png")
    appDelegate.navigationController.presentModalViewController(navigation, animated:true)
  end

end