module ApplicationHelper
  # For kaminari links
  def active_hash(page)
    opts = {}
    opts[:class] = "active" if page.current?
    return opts
  end

  # For sortable columns
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, { sort: column, direction: direction }, { class: css_class }
  end

  # Link to Markdown formatting tips
  def link_to_markdown_tips(message=nil)
    url = "http://markdown-guide.readthedocs.org/en/latest/basics.html"
    message ||= "Formatting help (external link)"
    link_to message, url, target: "_blank"
  end
  # link to the checkin report for a specific day
  def link_to_daily_checkins_for span
    report_path = daily_report_checkins_path(
      { year: span.year, month: span.month, day: span.day }
    )

    link_to span.strftime("%Y %b %d"), report_path
  end

  def link_to_monthly_checkins_for span
    report_path = monthly_report_checkins_path(
      { year: span.year, month: span.month }
    )

    link_to span.strftime("%Y %b"), report_path
  end
end

