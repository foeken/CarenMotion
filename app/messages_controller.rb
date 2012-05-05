class MessagesController < UITableViewController
  
  def init
    if super
      self.title = "Messages"      
    end
    self
  end
  
  def viewWillAppear(animated)
    addButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'addMessage')
    navigationItem.setRightBarButtonItem(addButton)
    # p CareProvider.all
  end
  
  def addMessage
    p "addMessage"
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    Message::All.size
  end
  
  def viewDidLoad
    view.dataSource = view.delegate = self
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    MessageCell.heightForMessage(Message::All[indexPath.row], tableView.frame.size.width)
  end
  
  def reloadRowForMessage(message)
    if row = Message::All.index(message)
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    MessageCell.cellForMessage(Message::All[indexPath.row], inTableView:tableView)
  end
  
end