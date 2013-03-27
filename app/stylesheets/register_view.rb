Teacup::Stylesheet.new :registerView do

  import :application

  style :password,
    returnKeyType: UIReturnKeyDone

  style :email,
    keyboardType: UIKeyboardTypeEmailAddress

  style :gender,
    backgroundColor: UIColor.clearColor,
    font: "HelveticaNeue".uifont(16),
    color: "#385487".uicolor,
    textAlignment: UITextAlignmentRight

  style :table_view,
    backgroundColor: UIColor.clearColor,
    opaque: false,
    separatorColor: UIColor.lightGrayColor

end