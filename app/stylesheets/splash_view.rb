Teacup::Stylesheet.new :splashView do

  import :application

  style :root, extends: :defaultRoot,
    image: "background_welcome.png".uiimage,
    contentMode: UIViewContentModeTop,
    userInteractionEnabled: true,
    backgroundColor: "#610743".uicolor

  style :menu, extends: :defaultTable,
    scrollEnabled: false,
    height: 99,
    top: (Device.screen.height - 169.0)

end