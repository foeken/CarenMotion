Teacup::Stylesheet.new :signInView do

  import :application

  style :avatar,
    image: "photo_empty.png".uiimage,
    constraints: [ :centered, constrain_top(39) ],
    width:  126,
    height: 126

  style :photoFrame,
    image: "photo_frame.png".uiimage,
    constraints: [ :centered, constrain_top(30) ],
    width:  148,
    height: 148

  style :email,
    keyboardType: UIKeyboardTypeEmailAddress

  style :forgotEmail,
    keyboardType: UIKeyboardTypeEmailAddress,
    autocorrectionType: UITextAutocorrectionTypeNo,
    backgroundColor: UIColor.whiteColor,
    frame: [[12.0, 45.0], [260.0, 25.0]]

  style :password,
    returnKeyType: UIReturnKeyDone

end