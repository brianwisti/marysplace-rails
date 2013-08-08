module ClientFlagsHelper
  # Build a table row for rendering this flag
  #
  # Uses Twitter Bootstrap CSS classes
  def row_for_client_flag(client_flag)
    if client_flag.is_resolved?
      row_class = "success"
    elsif client_flag.is_blocking
      row_class = "error"
    end

    if row_class
      haml_tag :tr, class: row_class do
        yield
      end
    else
      haml_tag :tr do
        yield
      end
    end
  end
end
