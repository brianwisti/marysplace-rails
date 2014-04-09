require "spec_helper"

describe UserMailer do
  let(:user) { create :user }

  before :all do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
  end

  before :each do
    user.reset_perishable_token!
    UserMailer.password_reset_notification(user).deliver
  end

  after :each do
    ActionMailer::Base.deliveries.clear
  end

  context "the email delivery" do
    subject { ActionMailer::Base.deliveries }
    its(:count) { should eq(1) }
  end

  context "the email message" do
    subject { ActionMailer::Base.deliveries.first }

    context "recipient" do
      its(:to) { should include(user.email) }
    end

    context "sender" do
      its(:from) { should include(ENV['ADMIN_EMAIL']) }
    end

    context "subject" do
      # let(:org_app_name) { "Mary's Place" }
      let(:org_app_name) { ENV['ADMIN_ORG_APP_NAME'] }
      its(:subject) { should eq(%{[#{org_app_name}] Password Reset Request Made For #{user.login}}) }
    end

    context "body" do
      its(:body) { should include(user.perishable_token) }
    end
  end

end
