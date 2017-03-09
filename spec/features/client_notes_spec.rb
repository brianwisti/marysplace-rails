require 'spec_helper'

feature "Client Notes" do
  fixtures :users

  background do
    @staff_amy = users :staff
    @fd_bella  = users :front_desk
  end

  scenario "Staff user sees Client Notes link" do
    sign_in @staff_amy
    visit root_path
    expect(page).to have_link("Client Notes")
    sign_out @staff_amy
  end

  scenario "Staff user sees link to create Client Note" do
    sign_in @staff_amy
    visit root_path
    click_link "Client Notes"
    expect(page).to have_link("Add a Note")
    sign_out @staff_amy
  end

  scenario "Front desk user sees no Client Notes link" do
    sign_in @fd_bella
    visit root_path
    expect(page).to_not have_link("Client Notes")
    sign_out @fd_bella
  end

end
