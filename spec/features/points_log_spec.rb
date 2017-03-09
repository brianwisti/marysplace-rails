require 'spec_helper'

feature 'Points Log' do
  fixtures :clients, :locations, :points_entry_types, :users
  background do
    @admin      = users :admin
    @location   = locations :overnight
    @client     = clients :amy_a
    @entry_type = points_entry_types :dishes

    sign_in @admin, password: 'waffle'
  end

  after do
    sign_out @admin
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
