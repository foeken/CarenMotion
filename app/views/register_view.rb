class RegisterView < DefaultView
  
  PERSONAL_INFO_SECTION = 0
   FIRST_NAME_ROW = 0
   LAST_NAME_ROW = 1
   EMAIL_ROW = 2
   PASSWORD_ROW = 3
  
  SEX_SECTION = 1
   SEX_ROW = 0
  
  RECEIVE_CARE_SECTION = 2
   RECEIVE_CARE_ROW = 0
  
  attr_accessor :firstNameTextField, :lastNameTextField, :emailTextField, :passwordTextField
  attr_accessor :receivesCareSwitch
  
  include TableViewWithScrolling
  
  def initWithFrame(rect)
    if super
      drawFields
      setupScrolling
    end
    self
  end
  
  def drawFields
    @tableView = GUI.defaultTableViewWithFrame(GUI.defaultTableViewPosition, dataSource:self, delegate:self)
    self.addSubview(@tableView)
    
    position = GUI.defaultFieldPositionInCell
    
    @firstNameTextField = GUI.textFieldWithFrame(position, delegate:self, placeholder:_("First name"))
    @lastNameTextField = GUI.textFieldWithFrame(position, delegate:self, placeholder:_("Last name"))
    @emailTextField = GUI.emailFieldWithFrame(position, delegate:self, placeholder:_("Email address"))
    @passwordTextField = GUI.textFieldWithFrame(position, delegate:self, placeholder:_("Password"))
    
    @passwordTextField.returnKeyType = UIReturnKeyDone
    
    @firstNameTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
    @lastNameTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
    @emailTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
    @passwordTextField.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
  end

  # ##########################
  # UITableView delegate methods
  # ##########################

  def numberOfSectionsInTableView tableView ; 3 ; end

  def tableView(tableView, heightForRowAtIndexPath:indexPath) ; 44 ; end
  
  def tableView(tableView, heightForHeaderInSection:section)
    case section
    when PERSONAL_INFO_SECTION, SEX_SECTION
      44
    when RECEIVE_CARE_SECTION
      0
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    case section
    when PERSONAL_INFO_SECTION
      return 4
    when SEX_SECTION, RECEIVE_CARE_SECTION
      return 1
    end
  end
  
  def tableView(tableView, viewForHeaderInSection:section)
    headerView = DefaultHeader.alloc.init
    case section
    when PERSONAL_INFO_SECTION
      headerView.imageView.image = UIImage.imageNamed("icon_personal_information.png")
      headerView.label.text = _("Personal information")
    when SEX_SECTION
      headerView.imageView.image = UIImage.imageNamed("icon_personal_information.png")
      headerView.label.text = _("Sex")
    when RECEIVE_CARE_SECTION
      # No label here
      return nil
    end
    return headerView
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    case indexPath.section
    when PERSONAL_INFO_SECTION
      case indexPath.row
      when FIRST_NAME_ROW
        cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"FirstNameCell")
        cell.contentView.addSubview @firstNameTextField
      when LAST_NAME_ROW
        cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"LastNameCell")
        cell.contentView.addSubview @lastNameTextField
      when EMAIL_ROW        
        cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"EmailCell")
        cell.contentView.addSubview @emailTextField
      when PASSWORD_ROW
        cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"PaswordCell")
        cell.contentView.addSubview @passwordTextField
      end
    when SEX_SECTION
      cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"SexCell")
    when RECEIVE_CARE_SECTION
      cell = GUI.dequeueOrDefaultCellForTableView(@tableView,"ReceiveCareCell")
    end
    return cell
  end
  
  def textFieldShouldReturn textField
    case textField
    when @firstNameTextField
      @lastNameTextField.becomeFirstResponder
    when @lastNameTextField
      @emailTextField.becomeFirstResponder
    when @emailTextField
      @passwordTextField.becomeFirstResponder
    when @passwordTextField
      @controller.clickedDoneButton
    end
    true
  end
  
end