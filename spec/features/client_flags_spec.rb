require 'spec_helper'

feature "Client Flags" do
  fixtures :clients, :client_flags, :users

  background do
    @admin = users :admin
    sign_in @admin
  end

  scenario "Displaying an resolved flag in a row" do
    click_link 'Client Flags'
    expect(page).to have_css('table tr.success')
  end

  scenario "Displaying an unresolved flag in a row" do
    click_link 'Client Flags'
    expect(page).to have_css('table tr:not(.danger):not(.success)')
  end

  scenario "Displaying an unresolved blocking flag in a row" do
    click_link 'Client Flags'
    expect(page).to have_css('table tr.danger')
  end
end
