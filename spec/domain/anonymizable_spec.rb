require 'anonymizable'

describe Anonymizable do
  let(:anonymizable) do
    Struct.new(:x, :y, :z) { extend Anonymizable }
  end

  let(:replacement) { "fnord" }

  describe ".define_anonymization_rule rule_name { rule }" do
    subject { anonymizable }

    it { should respond_to(:define_anonymization_rule) }

    context "creating" do
      let(:rule_name) { :fnorder }
      let(:rule)      { Proc.new { "fnord" } }
      subject { anonymizable.define_anonymization_rule(rule_name, &rule) }

      it { should eq(rule) }
    end
  end

  describe ".has_anonymization_rule? rule_name" do
    subject { anonymizable }

    it { should respond_to(:has_anonymization_rule?) }

    context "for nonexistent rule" do
      subject { anonymizable.has_anonymization_rule? :no_such_rule }

      it { should be_falsey }
    end

    context "for existing rule" do
      let(:rule_name) { :fnorder }

      before do
        anonymizable.define_anonymization_rule(rule_name) { "fnord" }
      end

      subject { anonymizable.has_anonymization_rule? rule_name }
      it { should be_truthy }
    end
  end

  describe ".get_anonymization_rule rule_name" do
    subject { anonymizable }

    it { should respond_to(:get_anonymization_rule) }

    context "when rule exists" do
      let(:rule_name) { :fnorder }
      let(:rule)      { Proc.new { "fnord" } }

      before do
        anonymizable.define_anonymization_rule rule_name, &rule
      end

      subject { anonymizable.get_anonymization_rule rule_name }
      it { should eq(rule) }
    end

    context "when rule does not exist" do
      subject { anonymizable.get_anonymization_rule :no_such_rule }
      it { should be_nil }
    end
  end

  describe ".forget_anonymization_rule rule_name" do
    subject { anonymizable }
    it { should respond_to(:forget_anonymization_rule) }

    context "existence of a deleted rule" do
      let(:rule) { :my_rule }

      before do
        anonymizable.define_anonymization_rule(rule) { "fnord" }
        anonymizable.forget_anonymization_rule rule
      end

      subject { anonymizable.has_anonymization_rule? rule }
      it      { should be_falsey }
    end
  end

  describe ".apply_rule rule_name" do
    subject { anonymizable }

    it { should respond_to(:apply_rule) }

    context "with a rule defined" do

      before do
        anonymizable.define_anonymization_rule :change_x do |a|
          a.x = replacement
        end
      end

      context "applied to an Anonymizable" do
        let(:thingy) { anonymizable.new }
        before       { anonymizable.apply_rule :change_x, thingy }

        it "performs expected replacements" do
          expect(thingy.x).to eq(replacement)
        end
      end
    end
  end

  describe ".anonymization_rule" do
    subject(:aliased) { anonymizable.method(:anonymization_rule) }
    it {
      should eq(anonymizable.method(:define_anonymization_rule))
    }
  end

  describe ".anonymizes(:field) { rule }" do
    subject { anonymizable }
    it      { should respond_to(:anonymizes) }

    context "for an existing field" do
      let(:field)      { :x }
      let(:rule)       { Proc.new { replacement } }

      before do
        anonymizable.anonymizes field, &rule
      end

      subject(:return) { anonymizable.anonymizes(field, &rule) }
      it               { should be_an_instance_of Proc }

      context "when applied" do
        let(:thing) { anonymizable.new }
        before          { anonymizable.anonymize! thing }

        it "performs expected replacements" do
          expect(thing.x).to eq(replacement)
        end
      end
    end
  end

  describe ".anonymize!" do
    subject { anonymizable }
    it      { should respond_to(:anonymize!) }

    before do
      anonymizable.define_anonymization_rule :change_x do |a|
        a.x = replacement
      end
    end

    context "applied to an Anonymizable" do
      let(:thingy) { anonymizable.new }
      before           { anonymizable.anonymize! thingy }

      it "performs expected replacements" do
        expect(thingy.x).to eq(replacement)
      end
    end
  end
end
