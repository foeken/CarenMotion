class RegisterView < DefaultView

  include TableViewBuilder
  include TableViewBuilder::KeyboardScrolling

  attr_accessor :tableView

  attr_accessor :firstNameTextField, :lastNameTextField, :emailTextField, :passwordTextField
  attr_accessor :receivesCareSwitch

  def initWithFrame(rect)
    if super
      drawFields
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

    enableScrollingOn [@firstNameTextField,@lastNameTextField,@emailTextField,@passwordTextField]
  end

  TableViewBuilder do |table|
    table.section do |section|
      section.height = 44
      section.header = _("Personal information")
      section.headerBuilder = lambda do |row,base|
        headerView = DefaultHeader.alloc.init
        headerView.imageView.image = UIImage.imageNamed("icon_personal_information.png")
        headerView
      end
      section.row do |row|
        row.reuseIdentifier = "FirstNameCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          cell.contentView.addSubview base.firstNameTextField
          cell
        end
      end
      section.row do |row|
        row.reuseIdentifier = "LastNameCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          cell.contentView.addSubview base.lastNameTextField
          cell
        end
      end
      section.row do |row|
        row.reuseIdentifier = "EmailCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          cell.contentView.addSubview base.emailTextField
          cell
        end
      end
      section.row do |row|
        row.reuseIdentifier = "PasswordCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          cell.contentView.addSubview base.passwordTextField
          cell
        end
      end
    end

    table.section do |section|
      section.header = _("Sex")
      section.height = 44
      section.headerBuilder = lambda do |row,base|
        headerView = DefaultHeader.alloc.init
        headerView.imageView.image = UIImage.imageNamed("icon_personal_information.png")
        headerView
      end
      section.row do |row|
      end
    end

    table.section do |section|
      section.row do |row|
      end
    end

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