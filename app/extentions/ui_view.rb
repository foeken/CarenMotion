class UIView
  
  attr_accessor :controller
  
  def findFirstResponder
    return self if self.firstResponder?    
    self.subviews.each do |view|
      return firstResponder if firstResponder = view.findFirstResponder
    end
    return nil
  end
  
end