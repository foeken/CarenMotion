class NSString

  def blank?
    self == "" || self.nil?
  end

  def present?
    !blank?
  end

end