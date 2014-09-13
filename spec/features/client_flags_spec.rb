require 'spec_helper'

feature "Client Flags" do
  background do
    @admin = create :admin_user
    sign_in @admin
  end

  scenario "Displaying an resolved flag in a row" do
    create :resolved_flag
    click_link 'Client Flags'
    expect(page).to have_css('table tr.success')
  end

  scenario "Displaying an unresolved flag in a row" do
    create :client_flag
    click_link 'Client Flags'
    expect(page).to have_css('table tr')
    expect(page).to_not have_css('table tr.danger')
    expect(page).to_not have_css('table tr.success')
  end

  scenario "Displaying an unresolved blocking flag in a row" do
    create :blocking_flag
    click_link 'Client Flags'
    expect(page).to have_css('table tr.danger')
  end
end
