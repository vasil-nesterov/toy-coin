# typed: false

describe String do
  let(:hex) { "fef359681e0718da983cb19674c93683d1db7efebed262407cfbb5f0d5d9a14b" }

  describe "#is_integer?" do
    it "returns true for an integer" do
      expect("123".is_integer?).to be(true)
    end

    it "returns false for a non-integer" do
      expect("123.45".is_integer?).to be(false)
    end
  end

  describe "#to_bytes, #to_hex" do
    it "converts string to bytes and back" do
      expect(
        hex.to_bytes.to_hex
      ).to eq(hex)
    end
  end
end
