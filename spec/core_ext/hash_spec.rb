# typed: false

describe Hash do
  describe "#to_stable_json" do
    let(:hash) { { 'a' => 1, 'c' => 3, 'b' => 2 } }

    it "produces a JSON string with keys in a stable order" do
      expect(
        hash.to_stable_json
      ).to eq(
        '{"a":1,"b":2,"c":3}'
      )
    end
  end
end
