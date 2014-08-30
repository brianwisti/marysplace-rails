# Simplifies definition of anonymization rules for a class
#
#   require 'anonymizable'
#   require 'faker' # Handy for generating fake data
#
#   class ImportantThing
#     extend Anonymizable
#     attr_accessor :name
#
#     anonymizes(:name) { Faker::Name.name }
#   end
#
#   thing = ImportantThing.new
#   # Load important things into your ImportantThing
#   thing.name = "President Hasselhoff"
#
#   # ... when suddenly you must anonymize! ...
#   ImportantThing.anonymize! thing
#
#   # or if you only care about a specific rule
#   ImportantThing.apply_rule :rule, thing
#   thing.name # => "Kayla Wehner"
#
# +anonymize!+ just invokes blocks. Ideally those blocks only
# directly touch the instance objects handed to them, but I will not
# enforce your coding habits from over here.
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
  #
  # NOTE: This is the primitive version. It assumes you know what
  # you're talking about. Any errors from applying rule +rule_name+
  # to your objects are between you and your code.
  #
  # +anonymization_rule+ is an alias.
  def define_anonymization_rule rule_name, &rule
    self.anonymization_rules[rule_name] = rule
  end

  alias_method :anonymization_rule, :define_anonymization_rule

  # Create a rule for anonymizing specific fields
  def anonymizes field_name, &rule
    self.define_anonymization_rule field_name do |instance|
      value    = rule.call instance
      accessor = field_name.to_s + "="
      instance.method(accessor).call value
    end
  end

  # Apply anonymization rule +rule_name+ to +instance+
  def apply_rule rule_name, instance
    rule = self.get_anonymization_rule rule_name
    rule.call instance
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

  # Apply all of my rules to +object+
  #
  # Order of rule application is not defined!
  def anonymize! object
    self.anonymization_rules.keys.each do |rule_name|
      self.apply_rule rule_name, object
    end
  end
end
