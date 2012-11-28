module TableViewBuilder
end

  module TableViewBuilder::KeyboardScrolling

    def init
      Notification.subscribe UIKeyboardWillShowNotification, action:"decreaseTableViewFrame", observer:self
      Notification.subscribe UIKeyboardWillHideNotification, action:"increaseTableViewFrame", observer:self
      super
    end

    def enableScrollingOn fields
      fields.each do |field|
        field.addTarget(self, action:"scrollToFirstResponder", forControlEvents:UIControlEventEditingDidBegin)
      end
    end

    def scrollToFirstResponder
      if firstResponder = self.findFirstResponder
        indexPath = @tableView.indexPathForCell( findFirstResponder.superview.superview )
        GUI.scrollTableView(@tableView, toRow:indexPath.row, inSection:indexPath.section)
      else
        @tableView.setContentOffset [0,0], animated:true
      end
    end

    # Decrease the size of the tableview so it fits between the keyboard
    def decreaseTableViewFrame
      GUI.withKeyboardAnimation do
        @tableView.setFrame GUI.reFrameWithKeyboard(@tableView.frame)
      end
      self.performSelector "scrollToFirstResponder", withObject:nil, afterDelay:0.1
    end

    # Increase the size of the tableview to the full bounds
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
