module TableViewBuilder
  class Row
    attr_accessor :title, :reuseIdentifier, :style
    attr_accessor :action, :target, :cellBuilder

    def initialize
      @reuseIdentifier = "CellIdentifier"
      @style = UITableViewCellStyleDefault
      @cellBuilder = lambda do |row,base|
        UITableViewCell.alloc.initWithStyle(row.style, reuseIdentifier:row.reuseIdentifier)
      end
    end
  end
end