class SignInView < DefaultView

  include TableViewBuilder
  include TableViewBuilder::KeyboardScrolling

  attr_accessor :tableView
  attr_accessor :emailTextField, :passwordTextField

  def initWithFrame(rect)
    if super
      self.stylesheet = :signInView
      drawFields
      drawHeader
    end
    self
  end

  def drawHeader
    @tableView.tableHeaderView = UIView.alloc.initWithFrame [[0.0, 0.0], [Device.screen.width, 195.0]]
    @tableView.tableHeaderView.subview(UIImageView, :avatar)
    @tableView.tableHeaderView.subview(UIImageView, :photoFrame)
  end

  def drawFields
    @emailTextField = subview(UITextField, :email, placeholder: _("Email address"))
    @passwordTextField = subview(UITextField, :password, placeholder: _("Password"))
    @tableView = subview(UITableView.alloc.initWithFrame(CGRect.new, style:UITableViewStyleGrouped), :defaultTable, dataSource:self, delegate:self)

    # TODO: Remove when Teacup#dummy.rb is updated
    @passwordTextField.secureTextEntry = true

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