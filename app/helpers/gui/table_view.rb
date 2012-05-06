class GUI
  
  def self.defaultTableViewPosition
    [[0.0, 0.0], [320.0, (460.0 - 44.0)]]
  end
  
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
  
  def self.dequeueOrDefaultNavigationCellForTableView tableView, identifier, &block
    tableView.dequeueReusableCellWithIdentifier(identifier) || begin
      cell = defaultNavigationCellWithIdentifier(identifier)
      yield(cell) if block_given?
      return cell
    end
  end
  
  def self.dequeueOrDefaultCellForTableView tableView, identifier, &block
    tableView.dequeueReusableCellWithIdentifier(identifier) || begin
      cell = defaultCellWithIdentifier(identifier)
      yield(cell) if block_given?
      return cell
    end
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
  
  def self.defaultTableViewWithFrame frame, dataSource:dataSource, delegate:delegate
    tableView = UITableView.alloc.initWithFrame(frame, style:UITableViewStyleGrouped)
    tableView.backgroundColor = UIColor.clearColor
    tableView.dataSource = dataSource
    tableView.delegate = delegate
    tableView.separatorColor = UIColor.lightGrayColor
    return tableView
  end
  
end