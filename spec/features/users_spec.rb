require 'spec_helper'

feature 'User Management' do
  fixtures :users

  background do
    @admin = users :admin
    sign_in @admin
  end

  after do
    sign_out @admin
  end

  scenario "add a new User" do
    attributes = {
      login: "New User",
      password: "waffle",
      password_confirmation: "waffle",
      email: "waffle@example.com"
    }

    visit root_path
    expect {
      click_link "Users"
      click_link "Create User"

      fill_in "Login", with: attributes[:login]
      fill_in 'user[password]', with: attributes[:password]
      fill_in "user[password_confirmation]", with: attributes[:password_confirmation]
      click_button "Create User"
    }.to change(User, :count).by(1)

    expect(page).to have_content "User created!"
    expect(page).to have_content attributes[:login]
  end
end
