# Simplifies definition of anonymization rules for a class
module Anonymizable
  def self.included base
    base.extend Hooks
  end 

  module Hooks
    # Defines a rule for anonymizing a specific field in an instance
    def anonymizes
    end
  end
end
