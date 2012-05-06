class DefaultView < UIImageView
  
  def initWithFrame(rect)
    if super
      self.image = UIImage.imageNamed('background_stripes.png')
      self.userInteractionEnabled = true
    end
    self
  end
  
end