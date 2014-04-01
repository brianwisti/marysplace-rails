require 'anonymizable'

class AnonymizableThing
  include Anonymizable
end

describe Anonymizable do

  describe ".anonymizes" do
    subject { AnonymizableThing }

    it { should respond_to(:anonymizes) }
  end

  describe "#anonymize!" do
    context "with no anonymization hooks"

    context "with anonymization hooks"

    context "with anonymization order specified"
  end

end
