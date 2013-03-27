class SplashView < UIImageView

  include TableViewBuilder
  attr_accessor :tableView

  def initWithFrame(rect)
    if super
      self.image = UIImage.imageNamed('background_welcome.png')
      self.contentMode = UIViewContentModeTop
      self.userInteractionEnabled = true
      self.backgroundColor = "#610743".uicolor
      drawNavigation
    end
    self
  end

  def drawNavigation
    position = [[0.0, (Device.screen.height - 99.0 - 70.0)], [Device.screen.width, 99.0]]
    @tableView = GUI.defaultTableViewWithFrame(position, dataSource:self, delegate:self)
    @tableView.scrollEnabled = false
    self.addSubview(@tableView)
  end

  TableViewBuilder do |table|
    table.section do |section|
      section.row do |row|
        row.title = _("I'm already a Caren user")
        row.reuseIdentifier = "NavigationCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultNavigationCellWithIdentifier("NavigationCell")
          cell.imageView.image = UIImage.imageNamed("icon_new_user.png")
          cell
        end
        row.action = :showSignIn
      end

      section.row do |row|
        row.title = _("I'm new to Caren")
        row.reuseIdentifier = "NavigationCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultNavigationCellWithIdentifier("NavigationCell")
          cell.imageView.image = UIImage.imageNamed("icon_existing_user.png")
          cell
        end
        row.action = :showRegister
      end
    end
  end

end