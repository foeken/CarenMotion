class MessageCell < UITableViewCell
  
  CellID = 'MessageCell'
  MessageFontSize = 14
  
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
  
  def self.cellForMessage(message, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(MessageCell::CellID) || MessageCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithMessage(message, inTableView:tableView)
    cell
  end
  
  def self.heightForMessage(message, width)
    constrain = CGSize.new(width - 57, 1000)
    size = message.body.sizeWithFont(UIFont.systemFontOfSize(MessageFontSize), constrainedToSize:constrain)
    [57, size.height + 8].max
  end
  
  def fillWithMessage(message, inTableView:tableView)
    self.textLabel.text = message.body
        
    unless message.image
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        image_data = NSData.alloc.initWithContentsOfURL(message.image_url)
        if image_data
          message.image = UIImage.alloc.initWithData(image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = message.image
            tableView.delegate.reloadRowForMessage(message)
          end
        end
      end
    else
      self.imageView.image = message.image
    end
  end
  
  def layoutSubviews
    super
    label_size = self.frame.size
    margin = (label_size.height - 49)/2   
    self.imageView.frame = [[2, margin], [49, 49]]
    self.textLabel.frame = [[57, 0,], [label_size.width - 59, label_size.height]]
  end
  
end