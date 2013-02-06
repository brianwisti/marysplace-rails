module ApplicationHelper
  # For kaminari links
  def active_hash(page)
    opts = {}
    opts[:class] = "active" if page.current?
    return opts
  end
end

