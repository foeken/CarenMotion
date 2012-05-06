class GUI
  
  def self.withAnimationDuration duration, andCurve:curve, &block 
    UIView.beginAnimations(nil, context:nil)
    UIView.animationDuration = duration
    UIView.animationCurve = curve
    yield
    UIView.commitAnimations
  end
  
  def self.withKeyboardAnimation &block
    GUI.withAnimationDuration(appDelegate.keyboardAnimationDuration, andCurve:appDelegate.keyboardAnimationCurve) do
      yield
    end
  end
  
end