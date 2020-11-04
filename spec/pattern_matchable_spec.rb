RSpec.describe PatternMatchable do
  it "has a version number" do
    expect(PatternMatchable::VERSION).not_to be nil
  end

  describe "#deconstruct_keys" do
    let(:klass) { Class.new }
    let(:target) { klass.class_eval { include PatternMatchable }; klass.new }
    subject { target.deconstruct_keys keys }

    context "valid method names" do
      let(:keys) { [:class, :__id__] }
      it { is_expected.to be_kind_of Hash }
      it { is_expected.to match(class: target.class, __id__: target.__id__) }
    end

    context "invalid method names" do
      let(:keys) { [:hoge, :foo] }
      it { expect { subject }.to raise_error NoMethodError }
    end
  end

  describe ".using" do
    context "using" do
      using PatternMatchable
      it { expect("".respond_to? :deconstruct_keys).to be_truthy }
      it { expect(0.respond_to? :deconstruct_keys).to be_truthy }
    end

    context "no using" do
      it { expect("".respond_to? :deconstruct_keys).to be_falsey }
      it { expect(0.respond_to? :deconstruct_keys).to be_falsey }
    end
  end

  describe ".refining" do
    using PatternMatchable.refining Array
    using PatternMatchable.refining String
    it { expect([].respond_to? :deconstruct_keys).to be_truthy }
    it { expect("".respond_to? :deconstruct_keys).to be_truthy }
    it { expect(0.respond_to? :deconstruct_keys).to be_falsey }
  end

  describe ".const_missing" do
    context "refining klass" do
      using PatternMatchable::Array
      using PatternMatchable::String
      it { expect([].respond_to? :deconstruct_keys).to be_truthy }
      it { expect("".respond_to? :deconstruct_keys).to be_truthy }
      it { expect(0.respond_to? :deconstruct_keys).to be_falsey }
    end

    context "nested" do
      using PatternMatchable::Enumerator::Lazy
      it { expect([].lazy.respond_to? :deconstruct_keys).to be_truthy }
    end
  end

  describe "PatternMatchable" do
    using PatternMatchable Array
    using PatternMatchable String
    it { expect([].respond_to? :deconstruct_keys).to be_truthy }
    it { expect("".respond_to? :deconstruct_keys).to be_truthy }
    it { expect(0.respond_to? :deconstruct_keys).to be_falsey }
  end
end
