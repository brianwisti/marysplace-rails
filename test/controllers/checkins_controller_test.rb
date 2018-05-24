require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  include Authlogic::TestCase


  setup :initialize_variables

  test "staff user can access index" do
    UserSession.create users(:staff)
    get :index

    assert_template :index
  end

  test "staff user can see some checkins on index" do
    UserSession.create users(:staff)
    get :index

    assert_not_nil assigns(:checkins)
  end

  test "staff user can access show" do
    UserSession.create users(:staff)
    get :show, id: @checkin

    assert_template :show
    assert_equal @checkin, assigns(:checkin),
      "... and can see the checkin"
  end

  test "staff user can access new" do
    UserSession.create users(:staff)
    get :new

    assert_template :new
  end

  test "staff user can access edit" do
    UserSession.create users(:staff)
    get :edit, id: @checkin

    assert_template :edit
    assert_equal @checkin, assigns(:checkin)
  end

  test "staff user can create a checkin" do
    UserSession.create users(:staff)
    initial_count = Checkin.count
    expected_count = initial_count + 1
    post :create, checkin: @attributes

    assert_equal expected_count, Checkin.count
    assert_redirected_to new_checkin_url
  end

  test "staff user can update a checkin" do
    UserSession.create users(:staff)
    @attributes[:notes] = "Notes here"
    put :update, id: @checkin, checkin: @attributes

    assert_equal @attributes[:notes], @checkin.reload.notes
  end

  test "staff user can destroy a checkin" do
    UserSession.create users(:staff)
    initial_count = Checkin.count
    expected_count = initial_count - 1
    checkin = checkins :amy_a_overnight
    delete :destroy, id: checkin

    assert_equal expected_count, Checkin.count
    assert_redirected_to checkins_url
  end

  test "staff user can access today's daily report" do
    UserSession.create users(:staff)
    get :today

    assert_template :daily_report
    assert_includes assigns(:checkins), @checkin
  end

  # TODO: Fix or remove checkin reports
  
  test "staff user can access selfcheck" do
    UserSession.create users(:staff)
    get :selfcheck

    assert_template :selfcheck
  end

  test "staff user can selfcheck a client" do
    badged_client = clients :badged_brenda
    location = locations :overnight
    initial_count = Checkin.count
    expected_count = initial_count + 1
    UserSession.create users(:staff)
    post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id

    assert_equal expected_count, Checkin.count
    assert_redirected_to selfcheck_checkins_url
    assert_not_nil flash[:notice]
  end

  test "user gets an error when creating an invalid selfcheck" do
    location = locations :overnight
    UserSession.create users(:staff)
    post :selfcheck_post, login: "12345678", location_id: location.id

    assert_not_nil flash[:alert]
  end

  test "user gets an error when duplicating a selfcheck" do
    badged_client = clients :badged_brenda
    location = locations :overnight
    initial_count = Checkin.count
    expected_count = initial_count + 1
    UserSession.create users(:staff)
    post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id
    post :selfcheck_post, login: badged_client.checkin_code, location_id: location.id

    assert_equal expected_count, Checkin.count
    assert_not_nil flash[:notice]
  end

  private

    def initialize_variables
      activate_authlogic

      @checkin = checkins :amy_a_overnight
      @today = Date.today
      @attributes = {
        client_id: clients(:amy_b),
        location_id: locations(:overnight),
        checkin_at: DateTime.now,
      }
    end

end
