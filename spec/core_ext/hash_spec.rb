# typed: false

describe Hash do
  describe "#stabilize" do
    context "with a simple hash" do
      let(:hash) { { "a" => 1, "c" => 3, "b" => 2 } }

      it "produces a hash with keys in a stable order" do
        expect(
          hash.stabilize
        ).to eq(
          { "a" => 1, "b" => 2, "c" => 3 }
        )
      end
    end

    context "with a deeply nested hash" do
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

      it "stabilizes deeply nested hashes" do
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
  end
end
