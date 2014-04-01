# Simplifies definition of anonymization rules for a class
module Anonymizable
  def self.included base
    base.send :include, Messages
    base.extend Rules
  end 

  module Rules
    # Defines a rule for anonymizing a specific field in an instance
    def anonymizes
    end

    # Returns my current rules for anonymizing an instance
    def anonymization_rules
    end
  end

  module Messages
    # Anonymizes my fields in accordance to my `anonymizes` rules
    def anonymize!
    end
  end
end
