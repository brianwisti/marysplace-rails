require 'anonymizable'

class AnonymizableThing
  include Anonymizable

  attr_accessor :my_data
end

describe Anonymizable do
  subject { AnonymizableThing }

  describe ".anonymizes" do
    it { should respond_to(:anonymizes) }
  end

  describe ".anonymization_rules" do
    it { should respond_to(:anonymization_rules) }
  end

  describe "#anonymize!" do
    subject { AnonymizableThing.new }

    it { should respond_to(:anonymize!) }

    context "with no anonymization hooks"

    context "with anonymization hooks"

    context "with anonymization order specified"
  end

end
