# typed: false

RSpec.describe In do
  let(:payload) { { "tx_id" => "abc123", "out_i" => 0 } }

  describe ".from_representation" do
    it "creates In from a hash" do
      input = In.from_representation(payload)

      expect(input).to be_a(In)
      expect(input.tx_id).to eq("abc123")
      expect(input.out_i).to eq(0)
    end
  end

  describe "#to_representation" do
    it "returns the representation" do 
      expect(
        In.from_representation(payload).to_representation
      ).to eq(payload)
    end
  end
end
