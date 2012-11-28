module TableViewBuilder
  class Table
    attr_accessor :sections

    def initialize
      @sections = []
    end

    def section
      newSection = Section.new
      yield newSection
      @sections << newSection
    end

    def rowsInSection(section)
      @sections[section].rows.count
    end

    def rowWithPath(path)
      @sections[path.section].rows[path.row]
    end
  end
end