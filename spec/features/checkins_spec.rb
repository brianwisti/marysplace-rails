require 'spec_helper'

feature "Client Checkins" do
  scenario "with no locations" do
    admin = create :admin_user
    client = create :client

    sign_in admin
    visit root_path
    click_link 'Checkins'
    click_link 'New Checkin'
    expect(page).to have_content("A Location is required for checkins")
    save_and_open_page
  end

  scenario "with one location"

  scenario "with two locations"
end
