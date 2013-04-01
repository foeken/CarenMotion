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

  def self.backBarButton title, target:target, action:action
    button = UIButton.buttonWithType(UIButtonTypeCustom)
    btnImage = "navigationbar_button_back.png".uiimage.stretchableImageWithLeftCapWidth(14, topCapHeight: 0)
    btnPressedImage = "navigationbar_button_back_light.png".uiimage.stretchableImageWithLeftCapWidth(14, topCapHeight: 0)

    button.titleLabel.font = "HelveticaNeue-Bold".uifont(13)
    button.titleLabel.textAlignment = UITextAlignmentRight
    button.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
    button.setTitleEdgeInsets UIEdgeInsetsMake(0.0, 6.0, 0.0, 0.0)

    buttonFrame = button.frame
    buttonFrame.size.width = title.sizeWithFont(button.titleLabel.font).width + 24.0;
    buttonFrame.size.height = btnImage.size.height
    button.frame = buttonFrame

    button.setBackgroundImage(btnImage, forState:UIControlStateNormal)
    button.setBackgroundImage(btnPressedImage, forState:UIControlStateHighlighted)
    button.setTitle(title, forState:UIControlStateNormal)

    button.addTarget(target, action:action, forControlEvents:UIControlEventTouchUpInside)

    return UIBarButtonItem.alloc.initWithCustomView(button)
  end

  def self.squareCancelBarButtonWithTarget target, action:action
    squareBarButtonWithTitle _("Cancel"), backgroundImage:"navigationbar_button_normal.png",
                                          backgroundImageTapped:"navigationbar_button_light.png",
                                          target:target,
                                          action:action
  end

  def self.squareBarButtonWithTitle title, target:target, action:action
    squareBarButtonWithTitle title, backgroundImage:"navigationbar_button_light.png",
                                    backgroundImageTapped:"navigationbar_button_normal.png",
                                    target:target,
                                    action:action
  end

  def self.squareBarButtonWithTitle title, backgroundImage:backgroundImage,
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