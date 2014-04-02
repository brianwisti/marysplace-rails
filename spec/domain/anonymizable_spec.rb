require 'anonymizable'

describe Anonymizable do
  let(:anonymizable) do
    Struct.new(:x, :y, :z) { extend Anonymizable }
  end

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

      it { should be_false }
    end

    context "for existing rule" do
      let(:rule_name) { :fnorder }

      before do
        anonymizable.define_anonymization_rule(rule_name) { "fnord" }
      end

      subject { anonymizable.has_anonymization_rule? rule_name }
      it { should be_true }
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

    context "when rule exists" do
      let(:rule) { :my_rule }

      before :each do
        anonymizable.define_anonymization_rule(rule) { "fnord" }
      end

      it "removes the rule" do
        anonymizable.forget_anonymization_rule(rule)
        expect(anonymizable.has_anonymization_rule?(rule)).to be_false
      end
    end
  end

end
