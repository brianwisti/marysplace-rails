require 'spec_helper'

feature 'Points Log' do
  background do
    @admin      = create :admin_user
    @location   = create :location
    @client     = create :client
    @entry_type = create :points_entry_type

    sign_in @admin, password: 'waffle'
  end

  scenario "Entering Points" do
    click_link 'Enter Points'
    fill_in 'current_alias', with: @client.current_alias
    fill_in 'points_entry_type', with: @entry_type.name
    fill_in 'points_entry_points_entered', with: @entry_type.default_points
    select @location.name, from: 'points_entry_location_id'
    click_button 'Create Points entry'
    expect(page).to have_content("Points entry was successfully created")
  end
end
