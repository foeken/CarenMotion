class GUI
      
  def self.customizeNavigationController navigationController, backgroundImage:backgroundImage
    navBar = navigationController.navigationBar
    
    if navBar.respondsToSelector "setBackgroundImage:forBarMetrics:"
      navBar.setBackgroundImage UIImage.imageNamed(backgroundImage), forBarMetrics:UIBarMetricsDefault
    else
      # Support for legacy SDK
      imageView1 = navBar.viewWithTag:kSCNavBarImageTag
      imageView2 = navBar.viewWithTag:kSCNavBarImageTag2
      
      if !imageView1
        imageView1 = UIImageView.alloc.initWithImage UIImageView.imageNamed(backgroundImage)
        imageView1.tag = kSCNavBarImageTag
        navBar.insertSubview(imageView1, atIndex:0)
      end
      
      if imageView2
        imageView1.alpha = 0
        UIView.beginAnimations(nil, context:nil)
        UIView.animationDuration = 0.5
        imageView1.alpha = 1
        UIView.commitAnimations
        imageView2.removeFromSuperview 
      end
    end
  end
  
  def self.show controller
    GUI.show(controller, modalTransitionStyle:UIModalTransitionStyleCoverVertical)
  end
  
  def self.show controller, modalTransitionStyle:modalTransitionStyle
    navigation = UINavigationController.alloc.initWithRootViewController( controller )
    navigation.modalTransitionStyle = modalTransitionStyle
    GUI.customizeNavigationController(navigation, backgroundImage:"navigationbar_background.png")
    appDelegate.navigationController.presentModalViewController(navigation, animated:true)
  end
  
  def self.squareBarButtonItemWithTitle title, backgroundImage:backgroundImage, 
                                               backgroundImageTapped:backgroundImageTapped, 
                                               target:target, 
                                               action:action
        
    button = UIButton.buttonWithType(UIButtonTypeCustom)
    backgroundImage = UIImage.imageNamed(backgroundImage).stretchableImageWithLeftCapWidth(6, topCapHeight:0)
    backgroundImageTapped = UIImage.imageNamed(backgroundImageTapped).stretchableImageWithLeftCapWidth(6, topCapHeight:0)
    
    button.titleLabel.font = buttonFont
    button.setTitleColor UIColor.whiteColor, forState:UIControlStateNormal
    button.setTitle(title, forState:UIControlStateNormal)
    
    frame = button.frame
    frame.size.width = title.sizeWithFont(buttonFont).width + 24
    frame.size.height = backgroundImage.size.height
    button.frame = frame
    
    button.setBackgroundImage(backgroundImage, forState:UIControlStateNormal)
    button.setBackgroundImage(backgroundImageTapped, forState:UIControlStateHighlighted)

    button.addTarget(target, action:action, forControlEvents:UIControlEventTouchUpInside)
    
    return UIBarButtonItem.alloc.initWithCustomView(button)
  end
  
end