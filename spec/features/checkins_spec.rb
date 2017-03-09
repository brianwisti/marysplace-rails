require 'spec_helper'

feature "Client Checkins" do
  fixtures :clients, :locations, :users

  background do
    @admin = users :admin
    @client = clients :anna_a
    sign_in @admin
    visit root_path
    click_link 'Show Checkins'
  end

  after do
    sign_out @admin
  end

  scenario "with no locations is impossible" do
    Location.destroy_all
    click_link 'New Checkin'
    expect(page).to have_content("A Location is required.")
  end

  scenario "with one location" do
    loc = locations :overnight
    click_link 'New Checkin'
    expect(page).to have_no_content("A Location is required for checkins")

    expect {
      fill_in 'current_alias', with: @client.current_alias
      select loc.name, from: 'Location'
      click_button "Create Checkin"
    }.to change(Checkin, :count).by(1)
  end


  scenario "with multiple locations" do
    loc_1 = locations :day_shelter
    loc_2 = locations :overnight

    click_link 'New Checkin'
    fill_in 'current_alias', with: @client.current_alias
    select loc_2.name, from: 'Location'
    click_button "Create Checkin"

    visit root_path
    click_link 'Show Checkins'
    click_link 'New Checkin'
    expect(find_field('checkin[location_id]').find('option[selected]').text).to eql(loc_2.name)
  end

end

feature "Self Checkin" do
  fixtures :clients, :locations, :users

  background do
    @admin = users :admin
    @client = clients :badged_brenda
    sign_in @admin
    visit root_path
    click_link 'Show Checkins'
  end

  scenario "selfcheck with no locations is impossible" do
    Location.destroy_all
    click_link 'Start Self Checkins'
    expect(page).to have_content("A Location is required for checkins")
    expect(page).to have_no_button("Checkin")
  end

  scenario "selfcheck with one location" do
    click_link 'Start Self Checkins'
    expect(page).to have_no_content("A Location is required for checkins")

    expect {
      fill_in 'login', with: @client.checkin_code
      click_button("Checkin")
    }.to change(Checkin, :count).by(1)
  end

  scenario "selfcheck with multiple locations" do
    loc_1 = locations :day_shelter
    loc_2 = locations :overnight
    click_link 'Start Self Checkins'

    fill_in 'login', with: @client.checkin_code
    select loc_2.name, from: '_location_id'
    click_button("Checkin")

    visit root_path
    click_link 'Show Checkins'
    click_link 'Start Self Checkins'
    expect(find_field('_location_id').find('option[selected]').text).to eql(loc_2.name)
  end
end
