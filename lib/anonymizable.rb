# Simplifies definition of anonymization rules for a class
module Anonymizable
  def self.extended base
    class << base
      attr_accessor :anonymization_rules
    end

    base.anonymization_rules = Hash.new
  end

  # Set a rule for anonymizing some information
  #
  # Will create a rule, or replace an existing rule.
  def define_anonymization_rule rule_name, &rule
    self.anonymization_rules[rule_name] = rule
  end

  # Remove an anonymization rule
  #
  # Removing a nonexistent rule is your business. This method
  # only cares that the rule does not exist when it's done.
  def forget_anonymization_rule rule_name
    self.anonymization_rules.delete rule_name
  end

  # Check for existence of a rule
  def has_anonymization_rule? rule_name
    self.anonymization_rules.has_key? rule_name
  end

  # Fetch a rule block by name
  #
  # Returns nil if the rule is not defined.
  def get_anonymization_rule rule_name
    self.anonymization_rules[rule_name]
  end
end
