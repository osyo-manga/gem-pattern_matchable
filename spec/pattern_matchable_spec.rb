RSpec.describe PatternMatchable do
  it "has a version number" do
    expect(PatternMatchable::VERSION).not_to be nil
  end

  describe "#deconstruct_keys" do
    subject { target.deconstruct_keys keys }

    context "include PatternMatchable" do
      let(:klass) { Class.new }
      let(:target) { klass.class_eval { include PatternMatchable }; klass.new }

      context "valid method names" do
        let(:keys) { [:itself, :__id__] }
        it { is_expected.to be_kind_of Hash }
        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      context "invalid method names" do
        let(:keys) { [:hoge, :foo] }
        it { expect { subject }.to raise_error NoMethodError }
      end
    end

    context "using PatternMatchable" do
      using PatternMatchable

      # MEMO: be to #deconstruct_keys after using.
      subject { target.deconstruct_keys keys }

      it { expect("".respond_to? :deconstruct_keys).to be_truthy }
      it { expect(0.respond_to? :deconstruct_keys).to be_truthy }

      context "not defined #deconstruct_keys and #respond_to?" do
        let(:target) { Class.new.new }
        let(:keys) { [:itself, :__id__] }

        it { is_expected.to be_kind_of Hash }
        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      # Not supported
      context "defined #deconstruct_keys" do
        let(:target) { { name: "homu" } }
        let(:keys) { [:itself, :__id__, :name] }

        it { is_expected.to be_kind_of Hash }
        it { is_expected.to match(name: "homu") }
      end
    end

    context "using PatternMatchable X" do
      context "not defined #deconstruct_keys and #respond_to?" do
        class X; end
        using PatternMatchable X

        # MEMO: be to #deconstruct_keys after using.
        subject { target.deconstruct_keys keys }

        let(:target) { X.new }
        let(:keys) { [:itself, :__id__] }

        it { is_expected.to be_kind_of Hash }
        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      context "defined #deconstruct_keys" do
        using PatternMatchable Hash

        # MEMO: be to #deconstruct_keys after using.
        subject { target.deconstruct_keys keys }

        let(:target) { { name: "homu" } }
        let(:keys) { [:name, :itself, :__id__] }

        it { is_expected.to be_kind_of Hash }
        it { is_expected.to match(name: "homu", itself: target.class, __id__: target.__id__) }
      end
    end
  end

  describe "pattern match" do
    describe "using PatternMatchable" do
      # MEMO: defined before using.
      class WithDefinedRespondTo
        def respond_to?(...)
          super
        end
      end

      using PatternMatchable

      # MEMO: be to #deconstruct_keys after using.
      subject { target => { itself: , __id__: }; { itself: itself, __id__: __id__ } }

      context "not defined #deconstruct_keys and #respond_to?" do
        let(:target) { Class.new.new }

        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      context "defined #deconstruct_keys" do
        let(:target) { {} }

        it { expect { subject }.to raise_error(NoMatchingPatternError) }
      end

      # Not supported
      context "defined #respond_to?" do
        let(:target) { WithDefinedRespondTo.new }

        it { expect { subject }.to raise_error(NoMatchingPatternError) }
      end
    end

    describe "using PatternMatchable X" do
      context "not defined #deconstruct_keys and #respond_to?" do
        class X; end
        using PatternMatchable X

        # MEMO: be to #deconstruct_keys after using.
        subject { target => { itself: , __id__: }; { itself: itself, __id__: __id__ } }

        let(:target) { X.new }

        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      context "defined #deconstruct_keys" do
        using PatternMatchable Hash

        # MEMO: be to #deconstruct_keys after using.
        subject { target => { itself: , __id__: }; { itself: itself, __id__: __id__ } }

        let(:target) { {} }

        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end

      context "defined #respond_to?" do
        using PatternMatchable WithDefinedRespondTo

        # MEMO: be to #deconstruct_keys after using.
        subject { target => { itself: , __id__: }; { itself: itself, __id__: __id__ } }

        let(:target) { WithDefinedRespondTo.new }

        it { is_expected.to match(itself: target, __id__: target.__id__) }
      end
    end
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
end
