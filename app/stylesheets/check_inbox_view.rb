Teacup::Stylesheet.new :checkInboxView do

  import :application

  style :envelop,
    image: "registered_envelop.png".uiimage,
    contentMode: UIViewContentModeTop,
    constraints: [ :centered, constrain_top(33) ],
    width:  216,
    height: 132

  style UILabel,
    width: Device.screen.width - 30,
    left: 15,
    height: 100,
    textColor: "#4c566c".uicolor,
    shadowColor: UIColor.whiteColor,
    shadowOffset: [0,1],
    textAlignment: UITextAlignmentCenter

  style :title,
    font: "HelveticaNeue-Bold".uifont(18),
    height: 20,
    top: 190

  style :body,
    font: "HelveticaNeue".uifont(15),
    numberOfLines: 9,
    height: 150,
    top: 225

end