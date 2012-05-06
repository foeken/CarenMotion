class SplashView < UIImageView

  SIGN_IN_ROW = 0
  REGISTER_ROW = 1

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
    
  # ##########################
  # UITableView delegate methods
  # ##########################
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    
    if appDelegate.connectionActive
      case indexPath.row
      when SIGN_IN_ROW
        GUI.show SignInController.alloc.init
      when REGISTER_ROW
        GUI.show RegisterController.alloc.init
      end
    else    
      alert _("No internet connection"), _("You can't do this without an internet connection.")
    end
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath) ; 44 ; end

  def tableView(tableView, numberOfRowsInSection:section) ; 2 ; end
    
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    GUI.dequeueOrDefaultNavigationCellForTableView(@tableView) do |cell|
      case indexPath.row
      when SIGN_IN_ROW
        cell.imageView.image = UIImage.imageNamed("icon_existing_user.png")
        cell.text = _("I'm already a Caren user")
      when REGISTER_ROW
        cell.imageView.image = UIImage.imageNamed("icon_new_user.png")
        cell.text = _("I'm new to Caren")
      end
      cell
    end
  end
  
end