module TableViewWithScrolling
  
  attr_accessor :tableView
  
  def scrollToFirstResponder
    if firstResponder = self.findFirstResponder
      indexPath = @tableView.indexPathForCell( findFirstResponder.superview.superview )
      GUI.scrollTableView(@tableView, toRow:indexPath.row, inSection:indexPath.section)
    else
      @tableView.setContentOffset [0,0], animated:true
    end
  end

  def decreaseTableViewFrame
    GUI.withKeyboardAnimation do
      @tableView.setFrame GUI.reFrameWithKeyboard(@tableView.frame)
    end
    self.performSelector "scrollToFirstResponder", withObject:nil, afterDelay:0.1
  end

  def increaseTableViewFrame
    GUI.withKeyboardAnimation do
      @tableView.setFrame self.bounds
    end
    self.performSelector "scrollToFirstResponder", withObject:nil, afterDelay:0.1
  end

  def dismissKeyboard
    firstResponder.resignFirstResponder if firstResponder = self.findFirstResponder
  end

end