class SplashView < UIImageView

  include TableViewBuilder
  attr_accessor :tableView

  def initWithFrame(rect)
    if super
      drawNavigation
    end
    self
  end

  def drawNavigation
    @tableView = subview(UITableView.alloc.initWithFrame(CGRect.new, style:UITableViewStyleGrouped), :menu, dataSource:self, delegate:self)
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