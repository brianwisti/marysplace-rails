require 'spec_helper'

feature "Client Checkins" do
  background do
    @admin = create :admin_user
    @client = create :client
    sign_in @admin
    visit root_path
    click_link 'Checkins'
  end

  scenario "with no locations is impossible" do
    click_link 'New Checkin'
    expect(page).to have_content("A Location is required for checkins")
    expect(page).to have_no_button("Create Checkin")
  end

  scenario "with one location" do
    create :location
    click_link 'New Checkin'
    expect(page).to have_no_content("A Location is required for checkins")

    expect {
      fill_in 'current_alias', with: @client.current_alias
      click_button("Create Checkin")
    }.to change(Checkin, :count).by(1)
  end

end
