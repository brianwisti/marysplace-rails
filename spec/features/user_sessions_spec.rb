require 'spec_helper'

feature 'User Sessions' do
  fixtures :users

  background do
    @login_header = "Please Sign In"
    @user = users :admin
    visit root_path
  end

  scenario "Anonymous Users" do
    expect(page).to have_content(@login_header)
  end

  scenario "Sign In" do
    fill_in 'login', with: @user.login
    fill_in 'password', with: "waffle"
    click_button 'Sign In'

    expect(page).to have_content(@user.login)
  end

  scenario "Sign Out" do
    sign_in @user
    click_link @user.login
    click_link "Sign Out"
    expect(page).to have_content(@login_header)
  end
end
