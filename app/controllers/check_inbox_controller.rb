class CheckInboxController < ApplicationController

  stylesheet :checkInboxView

  layout do
    self.view = layout(CheckInboxView, :root, controller: self)
  end

  def viewWillAppear(animated)
    @backButton = GUI.backBarButton _("Try again"), target:self, action:"clickedBackButton"
    @refreshButton = GUI.squareBarButtonWithTitle _("Refresh"), target:self, action:"clickedRefreshButton"
    self.navigationItem.rightBarButtonItem = @refreshButton
    self.navigationItem.leftBarButtonItem = @backButton
    self.title = _("Activate")
    super
  end

  def viewDidAppear(animated)
    self.view.animateEnvelope()
  end

  def clickedRefreshButton
    setLoading(true)
    setLoading(false)
    GUI.hideController(self)
    # TODO: Check if we can log in using the 'me' person now
  end

  def clickedBackButton
    self.navigationController.popViewControllerAnimated(true)
  end

end