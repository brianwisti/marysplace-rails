require 'test_helper'

class PointsEntryObserverTest < ActiveSupport::TestCase
  setup do
    @client = clients(:beth_b)
    @other_client = clients(:amy_a)
    @entry_type = points_entry_types(:dishes)
    @admin = users(:admin)
    @entry = PointsEntry.create!(client_id: @client.id,
                                 points_entry_type_id: @entry_type.id,
                                 performed_on: Date.today,
                                 added_by_id: @admin.id,
                                 points: @entry_type.default_points)
  end

  test "When a PointsEntry is created" do
    @client.reload
    assert_equal @entry.points, @client.point_balance,
      "its points are automatically counted in the Client's balance."
  end

  test "When a PointsEntry is deleted" do
    @entry.destroy
    @client.reload
    assert_equal @client.point_balance, 0
      "its points are automatically removed from the Client's balance."
  end

  test "When the points in a PointsEntry are updated" do
    new_points = 100
    @entry.update_attributes(points: new_points)
    @client.reload
    assert_equal @client.point_balance, new_points,
      "its change is tracked in the Client's balance."
  end

  test "When the client in a PointsEntry is changed" do
    new_balance = @other_client.point_balance + @entry.points
    @entry.update_attributes(client_id: @other_client.id)
    @client.reload
    assert_equal @client.point_balance, 0,
      "its points are removed from the original client."
    @other_client.reload
    assert_equal @other_client.point_balance, new_balance,
      "its points are added to the new client's balance."
  end

end
