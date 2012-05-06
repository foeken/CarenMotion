class GUI
    
  def self.emailFieldWithFrame frame, delegate:delegate, placeholder:placeholder
    field = textFieldWithFrame(frame, delegate:delegate, placeholder:placeholder)
    field.keyboardType = UIKeyboardTypeEmailAddress
    return field
  end
  
  def self.passwordFieldWithFrame frame, delegate:delegate, placeholder:placeholder
    field = textFieldWithFrame(frame, delegate:delegate, placeholder:placeholder)
    field.secureTextEntry = true
    return field
  end
  
  def self.textFieldWithFrame frame, delegate:delegate, placeholder:placeholder
    field = UITextField.alloc.initWithFrame(frame)
    field.font = GUI.fieldFont
    field.delegate = delegate
    field.textAlignment = UITextAlignmentLeft
    field.textColor = UIColor.blackColor
    field.autocapitalizationType = UITextAutocapitalizationTypeNone
    field.autocorrectionType = UITextAutocorrectionTypeNo
    field.placeholder = placeholder
    field.returnKeyType = UIReturnKeyNext
    return field
  end
  
end