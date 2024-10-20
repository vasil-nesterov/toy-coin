# typed: false

describe Hash do
  let(:hash) {
    {
      "a" => 1,
      "c" => {
        "cb" => 32,
        "ca" => {
          "cab" => 312,
          "caa" => 311
      } },
      "b" => 2
    }
  }

  describe "#stabilize" do
    it "stabilizes a deeply nested hash" do
      expect(
        hash.stabilize
      ).to eq(
        {
          "a" => 1,
          "b" => 2,
          "c" => {
            "ca" => {
              "caa" => 311,
              "cab" => 312
            },
            "cb" => 32
          }
        }
      )
    end
  end

  describe "#to_stable_json" do
    it "converts a hash to a JSON string with keys in a stable order" do
      expect(
        hash.to_stable_json
      ).to eq(
        '{"a":1,"b":2,"c":{"ca":{"caa":311,"cab":312},"cb":32}}'
      )
    end
  end
end
