class DefaultHeader < UIView
  
  attr_accessor :imageView, :label
  
  def init
    if super
      self.frame = [[0,0],[320,40]]
      self.backgroundColor = UIColor.clearColor
      
      @imageView = UIImageView.alloc.initWithFrame [[20,24],[16,14]]
      self.addSubview(@imageView)
      
      @label = UILabel.alloc.initWithFrame [[44,20],[(320.0 - 44.0), 20.0]]
      @label.backgroundColor = UIColor.clearColor
      @label.font = GUI.labelFont
      @label.textColor = UIColor.colorWithRed(0.298, green:0.337, blue:0.424, alpha:1) #4c566c
      @label.shadowColor = UIColor.whiteColor
      @label.shadowOffset = [0,1]
      self.addSubview(@label)
    end
    self
  end
  
end