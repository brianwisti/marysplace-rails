class PointsEntryObserver < ActiveRecord::Observer
  observe :points_entry

  def after_create(model)
    model.client.update_points!
  end

  def after_destroy(model)
    model.client.update_points!
  end

  def after_update(model)
    if model.points_changed?
      model.client.update_points!
    elsif model.client_id_changed?
      old_client = Client.find(model.client_id_was)
      old_client.update_points!
      model.client.update_points!
    end
  end
end
