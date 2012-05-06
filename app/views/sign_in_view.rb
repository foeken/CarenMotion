class SignInView < DefaultView
  
  include TableViewWithScrolling
  
  EMAIL_ROW = 0
  PASSWORD_ROW = 1
  FORGOT_PASSWORD_ROW = 2
  
  attr_accessor :emailTextField, :passwordTextField
  
  def initWithFrame(rect)
    if super
      drawFields
      drawImage
      setupScrolling
    end
    self
  end
      
  def drawImage
    headerView = UIView.alloc.initWithFrame [[0.0, 0.0], [320.0, 195.0]]
    
    photo = UIImageView.alloc.initWithFrame [[(320.0 / 2) - (126.0 / 2), 39.0], [126.0, 126.0]]
    photo.image = UIImage.imageNamed "photo_empty.png"
    
    photoFrame = UIImageView.alloc.initWithFrame [[(320.0 / 2) - (148.0 / 2), 30.0], [148.0, 148.0]]
    photoFrame.image = UIImage.imageNamed "photo_frame.png"
        
    headerView.addSubview(photo)
    headerView.addSubview(photoFrame)
    
    @tableView.tableHeaderView = headerView
  end
  
  def drawFields
    @tableView = GUI.defaultTableViewWithFrame(GUI.defaultTableViewPosition, dataSource:self, delegate:self)
    self.addSubview(@tableView)
    
    position = GUI.defaultFieldPositionInCell
    
    @emailTextField = GUI.emailFieldWithFrame(position, delegate:self, placeholder:_("Email address"))
    @passwordTextField = GUI.passwordFieldWithFrame(position, delegate:self, placeholder:_("Password"))
    @passwordTextField.returnKeyType = UIReturnKeyDone
        
    @emailTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
    @passwordTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
  end
  
  # ##########################
  # UITableView delegate methods
  # ##########################
    
  def tableView(tableView, heightForRowAtIndexPath:indexPath) ; 44 ; end

  def tableView(tableView, numberOfRowsInSection:section) ; 3 ; end
    
  def tableView(tableView, cellForRowAtIndexPath:indexPath)    
    case indexPath.row
    when EMAIL_ROW        
      cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"EmailCell")
      cell.contentView.addSubview @emailTextField
    when PASSWORD_ROW
      cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"PaswordCell")
      cell.contentView.addSubview @passwordTextField      
    when FORGOT_PASSWORD_ROW
      cell = GUI.dequeueOrDefaultNavigationCellForTableView(@tableView,"NavigationCell")
      cell.text = _("I forgot my password")
    end    
    return cell
  end
  
  def textFieldShouldReturn textField
    case textField
    when @emailTextField
      @passwordTextField.becomeFirstResponder
    when @passwordTextField
      @controller.clickedSignInButton
    end
    true
  end
  
end