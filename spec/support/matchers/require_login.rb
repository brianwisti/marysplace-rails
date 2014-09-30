RSpec::Matchers.define :expect_login do |attribute|
  match do |actual|
    expect(attribute).to \
      redirect_to Rails.application.routes.url_helpers.login_path
  end

  failure_message do |actual|
    "expected to require login to access the method"
  end

  description do
    "redirect to the login form"
  end
end
