module LocationsHelper
  def location_select form, field, user
    all_locations = Location.all
    default = Location.default_location_for user

    if all_locations.empty?
      content_tag :p do
        "A Location is required. A staff member must add one."
      end
    else
      form.collection_select field, all_locations, :id, :name,
        { selected: default.id },
        { class: 'form-control' }
    end
  end
end
