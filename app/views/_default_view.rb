class DefaultView < UIImageView

  def self.stylesheet stylesheet
    @stylesheet = stylesheet
  end

  def self.setStylesheet(instance)
    instance.stylesheet = @stylesheet if @stylesheet
  end

  def initWithFrame(rect)
    if super
      self.class.setStylesheet(self)
      self.render
    end
    self
  end

end