RSpec.describe Slack::Notifier::PayloadMiddleware do

  after(:each) do
    described_class.remove_instance_variable(:@registry)
  end

  describe "::registry" do
    it "returns a hash if nothing set" do
      expect( described_class.registry ).to eq({})
    end

    it "returns memoized version if already set" do
      described_class.instance_variable_set(:@registry, 'hodor')
      expect( described_class.registry ).to eq 'hodor'
    end
  end

  describe "::register" do
    it "adds given class to key in registry" do
      MyClass = Struct.new(:myclass)
      described_class.register MyClass, :my_class

      expect( described_class.registry[:my_class] ).to eq MyClass
    end
  end

end
