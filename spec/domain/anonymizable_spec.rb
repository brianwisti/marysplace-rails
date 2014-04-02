require 'anonymizable'

class AnonymizableThing
  include Anonymizable

  attr_accessor :my_data
end

describe Anonymizable do
  subject { AnonymizableThing }

  describe ".anonymizes" do
    it { should respond_to(:anonymizes) }

    it "accepts (:field, block)"
  end

  describe ".anonymization_rules" do
    it { should respond_to(:anonymization_rules) }
  end

  describe "#anonymize!" do
    subject { AnonymizableThing.new }

    it { should respond_to(:anonymize!) }

    context "with no anonymization hooks" do
      it "should not change fields" do
        thing = AnonymizableThing.new
        value = "fnord"
        thing.my_data = value
        thing.anonymize!

        expect(thing.my_data).to eql(value)
      end
    end

    context "with anonymization hooks"

    context "with anonymization order specified"
  end

end
