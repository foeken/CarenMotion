class TableViewBuilder::Section
  attr_accessor :header, :footer, :rows, :height
  attr_accessor :headerBuilder, :footerBuilder

  def initialize
    @rows = []
    @height = 0
  end

  def row
    newRow = TableViewBuilder::Row.new
    yield newRow
    @rows << newRow
  end
end