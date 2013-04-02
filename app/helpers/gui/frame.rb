class GUI

  def self.reFrameWithKeyboard frame
    [[frame.origin.x, frame.origin.y],[frame.size.width,frame.size.height - keyboardHeight]]
  end

  def self.keyboardHeight
    appDelegate.keyboardBounds.size.height || 0
  end

end