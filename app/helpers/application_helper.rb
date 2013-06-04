module ApplicationHelper
  # For kaminari links
  def active_hash(page)
    opts = {}
    opts[:class] = "active" if page.current?
    return opts
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end
end

