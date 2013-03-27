class RegisterView < DefaultView

  include TableViewBuilder
  include TableViewBuilder::KeyboardScrolling

  attr_accessor :tableView

  attr_accessor :firstNameTextField, :lastNameTextField, :emailTextField, :passwordTextField
  attr_accessor :receivesCareSwitch, :genderLabel

  def initWithFrame(rect)
    if super
      self.stylesheet = :registerView
      drawFields
    end
    self
  end

  def drawFields
    @firstNameTextField = subview(UITextField, :firstName, placeholder: _("First name"))
    @lastNameTextField  = subview(UITextField, :lastName, placeholder: _("Last name"))
    @emailTextField     = subview(UITextField, :email, placeholder: _("Email"))
    @passwordTextField  = subview(UITextField, :password, placeholder: _("Password"))
    @genderLabel        = subview(UILabel, :gender, text: _("Male"))
    @receivesCareSwitch = subview(UISwitch, :receivesCare)

    @tableView = GUI.defaultTableViewWithFrame(GUI.defaultTableViewPosition, dataSource:self, delegate:self)
    self.addSubview(@tableView)

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
        row.reuseIdentifier = "SexCell"
        row.action = lambda do |row,base|
          if base.genderLabel.text == _("Male")
            base.genderLabel.text = _("Female")
          else
            base.genderLabel.text = _("Male")
          end
        end
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          changeLabel = base.subview(UILabel, :tap_to_change_label, text: _("Tap to change"))

          Motion::Layout.new do |layout|
            layout.view cell.contentView
            layout.subviews "change_label" => changeLabel, "gender_label" => base.genderLabel
            layout.vertical "|[change_label]|"
            layout.vertical "|[gender_label]|"
            layout.horizontal "|-10-[change_label]-10-[gender_label]-10-|"
          end
          cell
        end
      end
    end

    table.section do |section|
      section.row do |row|
        row.reuseIdentifier = "ReceiveCareCell"
        row.cellBuilder = lambda do |row,base|
          cell = GUI.defaultCellWithIdentifier row.reuseIdentifier
          label = base.subview(UILabel, :receive_care_label, text: _("I receive care myself"))
          Motion::Layout.new do |layout|
            layout.view cell.contentView
            layout.subviews "switch" => base.receivesCareSwitch, "label" => label
            layout.vertical "|-8-[switch]-8-|"
            layout.vertical "|[label]|"
            layout.horizontal "|-10-[label]-10-[switch]-10-|"
          end
          cell
        end
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