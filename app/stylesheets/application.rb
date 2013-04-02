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

  style :defaultTable,
    backgroundColor: UIColor.clearColor,
    backgroundView: nil,
    separatorColor: "#c6cace".uicolor,
    separatorStyle: UITableViewCellSeparatorStyleNone,
    width: Device.screen.width,
    height: Device.screen.height - 64.0

  style :defaultRoot,
    image: "background_stripes.png".uiimage,
    userInteractionEnabled: true

  style :root, extends: :defaultRoot

end