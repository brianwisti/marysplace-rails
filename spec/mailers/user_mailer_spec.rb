require "spec_helper"

describe UserMailer, :type => :mailer do
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
    it "is counted" do
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end
  end

  context "the email message" do
    let(:msg) { ActionMailer::Base.deliveries.first }

    it "remembers the recipient" do
      expect(msg.to).to include(user.email)
    end

    it "remembers the sender" do
      expect(msg.from).to include(ENV['ADMIN_EMAIL'])
    end

    it "remembers the subject" do
      app_name = ENV['ADMIN_ORG_APP_NAME']
      login    = user.login
      subject  = %{[#{app_name}] Password Reset Request Made For #{login}}
      expect(msg.subject).to eq(subject)
    end

    it "remembers the body" do
      expect(msg.body).to include(user.perishable_token)
      expect(msg.body).to include(ENV['APP_HOSTNAME'])
    end
  end

end
