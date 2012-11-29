module Kernel
  private

  # Gettext like translation string syntax
  def _(key,value="")
    NSBundle.mainBundle.localizedStringForKey(key, value:value, table:nil)
  end

  def appDelegate
    UIApplication.sharedApplication.delegate
  end

  def caren
    appDelegate.caren
  end

  def alert title, message
    UIAlertView.alloc.initWithTitle(title,
                                    message: message,
                                    delegate: nil,
                                    cancelButtonTitle: _("Ok"),
                                    otherButtonTitles: nil).show
  end

  def subscribe name, action
    Notification.subscribe name, action:action, observer:self
  end

  def unsubscribe name
    Notification.unsubscribe name, observer:self
  end

  def setLoading(toggle)
    if toggle
      SVProgressHUD.showWithStatus(_("Loading"), maskType:SVProgressHUDMaskTypeGradient)
    else
      SVProgressHUD.dismiss
    end
  end

end