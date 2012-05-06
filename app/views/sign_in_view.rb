class SignInView < UIImageView
  
  attr_accessor :tableView
  
  def initWithFrame(rect)
    if super
      self.image = UIImage.imageNamed('background_stripes.png')
      self.userInteractionEnabled = true
      drawFields
      drawImage
    end
    self
  end
  
  def drawImage
    headerView = UIView.alloc.initWithFrame [[0.0, 0.0], [320.0, 195.0]]
    
    photo = UIImageView.alloc.initWithFrame [[(320.0 / 2) - (126.0 / 2), 29.0], [126.0, 126.0]]
    photo.image = UIImage.imageNamed "photo_empty.png"
    
    photoFrame = UIImageView.alloc.initWithFrame [[(320.0 / 2) - (148.0 / 2), 29.0], [148.0, 148.0]]
    photoFrame.image = UIImage.imageNamed "photo_frame.png"
        
    headerView.addSubview(photo)
    headerView.addSubview(photoFrame)
    
    @tableView.tableHeaderView = headerView
  end
  
  def drawFields
    position = [[0.0, 0.0], [320.0, (460.0 - 44.0)]]
    @tableView = GUI.defaultTableViewWithFrame(position, dataSource:self, delegate:self)
    self.addSubview(@tableView)
  end
  
  # ##########################
  # UITableView delegate methods
  # ##########################
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  end
  
  def tableView(tableView, heightForRowAtIndexPath:indexPath) ; 44 ; end

  def tableView(tableView, numberOfRowsInSection:section) ; 3 ; end
    
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
  end
  
end