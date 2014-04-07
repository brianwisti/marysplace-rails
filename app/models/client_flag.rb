require 'anonymizable'

class ClientFlag < ActiveRecord::Base
  extend Anonymizable

  attr_accessible :action_required, :consequence, :client_id, :created_by, :created_by_id,
    :description, :expires_on, :is_blocking, :resolved_by_id, :resolved_on, :can_shop

  belongs_to :client
  belongs_to :created_by,
    class_name: "User"
  belongs_to :resolved_by,
    class_name: "User"

  validates :client,
    presence: true
  validates :created_by,
    presence: true

  default_scope order('created_at DESC')
  scope :resolved, where(["resolved_on is not null or expires_on <= ?", Date.today])
  scope :unresolved, where(["(resolved_on is null) and (expires_on is null or expires_on > ?)", Date.today])

  delegate :current_alias,
    to:     :client,
    prefix: true
  delegate :login,
    to:     :created_by,
    prefix: true
  delegate :login,
    to:     :resolved_by,
    prefix: true

  def self.active_count
    unresolved.count
  end

  def is_resolved?
    today = Date.today

    if self.resolved_on and self.resolved_on <= today
      return true
    end

    if self.expires_on and self.expires_on <= today
      return true
    end

    return false
  end

  after_save do
    if self.is_resolved?
      if self.client.is_flagged == true
        self.client.update_attributes is_flagged: false
      end
    else
      if self.client.is_flagged == false
        self.client.update_attributes is_flagged: true
      end
    end
  end

  anonymizes(:consequence)     { Faker::Lorem.paragraph }
  anonymizes(:action_required) { Faker::Lorem.paragraph }

  anonymizes :description do |flag|
    # Let some automatically generated descriptions pass.
    if flag.description =~ /^Bailed on .+ ([-\d]+)$/
      "Bailed on chore #{$1}"
    else
      Faker::Lorem.paragraph
    end
  end
end
