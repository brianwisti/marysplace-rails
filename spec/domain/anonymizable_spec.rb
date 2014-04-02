require 'anonymizable'

class AnonymizableThing
  include Anonymizable

  attr_reader :w, :x, :y, :z

  def initialize
    @x = "aardvark"
    @y = "banana"
    @z = "crepe"
  end

  anonymizes(:x) { "fnord" }

  anonymizes :y do |thing|
    thing.y.upcase 
  end
end

describe Anonymizable do
  subject { AnonymizableThing }

  describe "#anonymize!" do
    let(:thing)      { AnonymizableThing.new }
    let(:anonymized) { AnonymizableThing.new.anonymize! }

    context "field with no anonymization rule" do
      it "should be unchanged" do
        expect(anonymized.z).to eq(thing.z)
      end
    end
  end

end
