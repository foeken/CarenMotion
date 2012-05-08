class SplashView < UIImageView
  
  include TableViewBuilder
  attr_accessor :tableView
  
  def initWithFrame(rect)
    if super
      self.image = UIImage.imageNamed('background_welcome.png')
      self.userInteractionEnabled = true
      drawNavigation
    end
    self
  end
  
  def drawNavigation
    position = [[0.0, (460.0 - 99.0 - 50.0)], [320.0, 99.0]]    
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
        row.action = lambda do
          if appDelegate.connectionActive
            GUI.showController SignInController.alloc.init
          else
            alert _("No internet connection"), _("You can't do this without an internet connection.")
          end          
        end
      end
      
      section.row do |row|
        row.title = _("I'm new to Caren")
        row.reuseIdentifier = "NavigationCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultNavigationCellWithIdentifier("NavigationCell")
          cell.imageView.image = UIImage.imageNamed("icon_existing_user.png")
          cell
        end
        row.action = lambda do
          if appDelegate.connectionActive
            GUI.showController RegisterController.alloc.init
          else
            alert _("No internet connection"), _("You can't do this without an internet connection.")
          end
        end
      end
    end
  end

end