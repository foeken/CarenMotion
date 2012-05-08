module TableViewBuilder
  
  module ClassMethods
    def TableViewBuilder
      @table = TableViewBuilder::Table.new
      yield @table
    end
    
    def table
      @table
    end
  end
  
  def self.included(child)
    child.extend ClassMethods
  end
  
  def table
    @table ||= self.class.table
  end

  def tableView(tableView, cellForRowAtIndexPath:path)
    return unless table
    row = table.rowWithPath(path)
    
    cell = tableView.dequeueReusableCellWithIdentifier(row.reuseIdentifier)
    cell = row.cellBuilder.call(row,self) unless cell
    
    cell.reuseIdentifier = row.reuseIdentifier
    cell.textLabel.text = row.title
    cell.detailTextLabel.text = row.detail if cell.detailTextLabel

    cell
  end

  def numberOfSectionsInTableView(tableView)
    table ? table.sections.count : 0
  end
  
  def tableView(tableView, heightForHeaderInSection:section)
    table ? table.sections[section].height : 0
  end

  def tableView(tableView, numberOfRowsInSection:section)
    table ? table.rowsInSection(section) : 0
  end

  def tableView(tableView, titleForHeaderInSection:section)
    if table
      section = table.sections[section]
      if section.headerBuilder
        return nil
      else
        return section.header
      end
    end
    return nil
  end
  
  def tableView(tableView, viewForHeaderInSection:section)
    section = table.sections[section]
    if section.headerBuilder
      headerView = section.headerBuilder.call(section,self)
      headerView.label.text = section.header
      return headerView
    end
    return nil
  end

  def tableView(tableView, titleForFooterInSection:section)
    if table
      section = table.sections[section]
      if section.footerBuilder
        return nil
      else
        return section.footer
      end
    end
    return nil
  end
  
  def tableView(tableView, viewForFooterInSection:section)
    section = table.sections[section]
    if section.footerBuilder
      footerView = section.footerBuilder.call(section,self)
      footerView.label.text = section.footer
      return footerView
    end
    return nil
  end

  def tableView(tableView, commitEditingStyle:editing_style, forRowAtIndexPath:path)
  end

  def tableView(tableView, canEditRowAtIndexPath:path)
    false
  end

  def tableView(tableView, canMoveRowAtIndexPath:path)
    false
  end

  def tableView(tableView, moveRowAtIndexPath:start_path, toIndexPath:dest_path)
  end

  def tableView(tableView, didSelectRowAtIndexPath:path)
    return unless table
    row = table.rowWithPath(path)

    if row.action
      if row.action.is_a? Proc
        row.action.call()
      else
        if row.target
          row.target.send(row.action)
        else
          self.send(row.action)
        end
      end
    end
  end
end