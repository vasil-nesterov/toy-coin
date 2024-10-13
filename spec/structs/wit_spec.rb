# typed: strict

RSpec.describe Wit do
  T.bind(self, T.untyped)

  let(:payload) {
    {
      "pub" => "public_key",
      "sgn" => "signature"
    }
  }

  describe ".from_representation" do
    it "creates a Wit from a hash" do
      wit = Wit.from_representation(payload)

      expect(wit.pub).to eq("public_key")
      expect(wit.sgn).to eq("signature")
    end
  end

  describe "#to_representation" do
    it "returns a hash representation of the Wit" do
      expect(
        Wit.from_representation(payload).to_representation
      ).to eq(payload)
    end
  end
end
