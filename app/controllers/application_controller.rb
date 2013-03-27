class ApplicationController < UIViewController

  def loadView
    if self.view
      self.view.controller = self
      self.view.setNeedsDisplay
    end
  end

end