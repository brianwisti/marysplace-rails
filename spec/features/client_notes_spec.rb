require 'spec_helper'

feature "Client Notes" do
  background do
    @staff_amy = create :staff_user
    @fd_bella  = create :front_desk_user
  end

  scenario "Staff user sees Client Notes link" do
    sign_in @staff_amy
    visit root_path
    expect(page).to have_link("Client Notes")
  end

  scenario "Front desk user sees no Client Notes link" do
    sign_in @fd_bella
    visit root_path
    expect(page).to_not have_link("Client Notes")
  end

end
