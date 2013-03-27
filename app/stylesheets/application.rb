Teacup::Stylesheet.new :application do

  style UISwitch,
    onTintColor: "#ca0b7c".uicolor

  style UITextField,
    frame: GUI.defaultFieldPositionInCell,
    font: "HelveticaNeue-Bold".uifont(16),
    autocapitalizationType: UITextAutocapitalizationTypeNone,
    autocorrectionType: UITextAutocorrectionTypeNo,
    returnKeyType: UIReturnKeyNext

  style UILabel,
    backgroundColor: UIColor.clearColor,
    font: "HelveticaNeue-Bold".uifont(16)

end