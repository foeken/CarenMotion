class Message
  
  attr_accessor :image_url, :body, :image
  
  def initialize image_url, body
    @image_url = NSURL.alloc.initWithString(image_url)
    @body = body
  end
  
  All = [
    Message.new("http://img.photobucket.com/albums/v29/Staleghoti/BACON.png","Hello world"),
    Message.new("http://img.photobucket.com/albums/v29/Staleghoti/BACON.png","Everything is ok\nBut not THAT ok"),
    Message.new("http://img.photobucket.com/albums/v29/Staleghoti/BACON.png","Nope all is well"),
    Message.new("http://img.photobucket.com/albums/v29/Staleghoti/BACON.png","Does this work?")
  ]
  
end