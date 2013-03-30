class GUI

  def self.defaultFieldPositionInCell
    [[8, ((43.0 - 20.0) / 2) + 0.5], [280.0, 20.0]]
  end

  def self.scrollTableView tableView, toRow:row
    scrollTableView(tableView, toRow:row, inSection:0)
  end

  def self.scrollTableView tableView, toRow:row, inSection:section
    tableView.scrollToRowAtIndexPath NSIndexPath.indexPathForRow(row, inSection:section),
                                     atScrollPosition:UITableViewScrollPositionMiddle,
                                     animated:true
  end

  def self.defaultNavigationCellWithIdentifier identifier
    cell = defaultCellWithIdentifier(identifier)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    return cell
  end

  def self.defaultCellWithIdentifier identifier
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell.textLabel.font = labelFont
    return cell
  end

end