module PointsEntryTypesHelper
  def entry_type_label entry_type
    pieces = [
      ERB::Util.h(entry_type.name)
    ]

    unless entry_type.is_active

      pieces << content_tag(:span, "Inactive", class: "label label-default").html_safe
    end

    pieces.join(' ').html_safe
  end
end
