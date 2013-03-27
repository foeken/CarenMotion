class SignInView < DefaultView

  include TableViewBuilder
  include TableViewBuilder::KeyboardScrolling

  attr_accessor :tableView
  attr_accessor :emailTextField, :passwordTextField

  def initWithFrame(rect)
    if super
      self.stylesheet = :signInView
      drawFields
      drawImage
    end
    self
  end

  def drawImage
    headerView = UIView.alloc.initWithFrame [[0.0, 0.0], [Device.screen.width, 195.0]]
    avatar = headerView.subview(UIImageView, :avatar)
    photoFrame = headerView.subview(UIImageView, :photoFrame)
    @tableView.tableHeaderView = headerView
  end

  def drawFields
    @emailTextField = subview(UITextField, :email, placeholder: _("Email address"))
    @passwordTextField = subview(UITextField, :password, placeholder: _("Password"))
    @passwordTextField.secureTextEntry = true

    @tableView = GUI.defaultTableViewWithFrame(GUI.defaultTableViewPosition, dataSource:self, delegate:self)
    self.addSubview(@tableView)

    enableScrollingOn [@emailTextField, @passwordTextField]
  end

  TableViewBuilder do |table|
    table.section do |section|
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
      section.row do |row|
        row.title = _("I forgot my password")
        row.reuseIdentifier = "ForgotCell"
        row.cellBuilder = lambda do |row,base|
          GUI.defaultNavigationCellWithIdentifier row.reuseIdentifier
        end
      end
    end
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