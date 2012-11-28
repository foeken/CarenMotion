class SignInView < DefaultView

  include TableViewBuilder
  include TableViewBuilder::KeyboardScrolling

  attr_accessor :tableView
  attr_accessor :emailTextField, :passwordTextField

  def initWithFrame(rect)
    if super
      drawFields
      drawImage
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
        row.reuseIdentifier = "EmailCell"
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