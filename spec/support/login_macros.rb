module LoginMacros

  # A session starter that talks directly to the database
  def login(user)
    expect(user).to_not be_nil
    session = UserSession.create!(user, false)
    expect(session).to be_valid
    session.save
    return session
  end

  # A session ender that talks directly to the database
  def logout user
    expect(user).to_not be_nil
    session = UserSession.find
    expect(session).to be_valid
    session.destroy
  end

  # A session starter that interacts with the site interface
  def sign_in(user, password: 'waffle')
    visit root_path
    fill_in "Login",    with: user.login
    fill_in "Password", with: password
    click_button "Sign In"
  end

  # A session ender that interacts with the site interface
  def sign_out user
    first(:link, user.login).click
    click_link "Sign Out"
  end

end
