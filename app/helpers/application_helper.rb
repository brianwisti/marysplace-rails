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

  # link to the checkin report for a specific day
  def link_to_daily_checkins_for span
    report_path = daily_report_checkins_path(
      { year: span.year, month: span.month, day: span.day }
    )
    link = link_to span.strftime("%Y %b %d"), report_path
    return link
  end
end

