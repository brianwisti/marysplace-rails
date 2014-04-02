# Simplifies definition of anonymization rules for a class
module Anonymizable
  def self.included base
    class << base
      @@anonymization_rules = Hash.new
    end

    base.send :include, Messages
    base.extend Rules
  end 

  module Rules
    # Defines a rule for anonymizing a specific field in an instance
    def anonymizes field, &block

      if block_given?
        # who cares?
      end

      return field
    end
  end

  module Messages
    # Anonymizes my fields in accordance to my `anonymizes` rules
    def anonymize!
      return self
    end
  end
end
