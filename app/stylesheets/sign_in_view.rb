Teacup::Stylesheet.new :signInView do

  import :application

  style :avatar,
    image: "photo_empty.png".uiimage,
    constraints: [ :centered, constrain_top(30) ],
    width:  126,
    height: 126

  style :photoFrame,
    image: "photo_frame.png".uiimage,
    constraints: [ :centered ],
    width:  148,
    height: 148

  style :email,
    keyboardType: UIKeyboardTypeEmailAddress

  style :password,
    returnKeyType: UIReturnKeyDone

end