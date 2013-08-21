require 'spec_helper'

feature 'User Management' do
  scenario "add a new User" do
    attributes = attributes_for :user
    admin = create(:admin_user)

    visit root_path
    fill_in "Login",    with: admin.login
    fill_in "Password", with: admin.password
    click_button "Login"

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
