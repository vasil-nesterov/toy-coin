# typed: strict

RSpec.describe ChainTweaks do
  T.bind(self, T.untyped)

  describe ".from_representation" do
    it "creates a ChainTweaks instance from a hash" do
      payload = { "complexity" => 10 }
      chain_tweaks = ChainTweaks.from_representation(payload)

      expect(chain_tweaks).to be_a(ChainTweaks)
      expect(chain_tweaks.complexity).to eq(10)
    end

    it "handles nil complexity" do
      payload = {}
      chain_tweaks = ChainTweaks.from_representation(payload)

      expect(chain_tweaks.complexity).to be_nil
    end
  end

  describe "#to_representation" do
    it "returns a hash representation" do
      chain_tweaks = ChainTweaks.new(complexity: 5)
      representation = chain_tweaks.to_representation

      expect(representation).to eq({ "complexity" => 5 })
    end

    it "returns nil when complexity is not set" do
      chain_tweaks = ChainTweaks.new
      representation = chain_tweaks.to_representation

      expect(representation).to be_nil
    end
  end
end