RSpec::Matchers.define :expect_login do |attribute|
  match do |actual|
    expect(attribute).to \
      redirect_to Rails.application.routes.url_helpers.login_path
  end

  failure_message_for_should do |actual|
    "expected to require login to access the method"
  end

  failure_message_for_should_not do |actual|
    "expected not to require login to access the method"
  end

  description do
    "redirect to the login form"
  end
end
