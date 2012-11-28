module LoadingView

  def setLoading(toggle, view = self.view)
    if toggle
      @loadingView = UIView.alloc.initWithFrame(view.bounds)
      @loadingView.setBackgroundColor(UIColor.scrollViewTexturedBackgroundColor)
      @loadingView.setAlpha(0.7)
      @indicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
      view.addSubview(@loadingView)
      @loadingView.addSubview(@indicator)
      @indicator.setFrame(CGRectMake((Device.screen.width/2)-20, (Device.screen.height/2)-90, 40, 40))
      @indicator.startAnimating
    else
      @loadingView.removeFromSuperview
    end
  end

end