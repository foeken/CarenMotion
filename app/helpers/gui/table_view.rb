class GUI
  
  def self.dequeueOrDefaultNavigationCellForTableView tableView, &block
    tableView.dequeueReusableCellWithIdentifier("CellIdentifier") || begin
      cell = defaultNavigationCellWithIdentifier("CellIdentifier")
      yield(cell)
    end
  end
  
  def self.defaultNavigationCellWithIdentifier identifier
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:identifier)
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
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