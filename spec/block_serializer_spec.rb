# typed: strict

RSpec.describe BlockSerializer do
  T.bind(self, T.untyped)

  let(:payload) {
    {
      "ver" => Block::CURRENT_VERSION,
      "prev_dgst" => "previous_digest",
      "nonce" => 12345,
      "chain_tweaks" => { "complexity" => 10 },
      "txs" => [
        {
          "dgst" => "tx_digest",
          "at" => "2024-01-01T00:00:00Z",
          "ins" => [],
          "outs" => [],
          "wits" => []
        }
      ]
    }
  }
  let(:block) { BlockSerializer.from_representation(payload) }

  describe ".from_representation" do
    it "returns a Block instance" do
      expect(block).to be_a(Block)
    end
  end

  describe "#full_representation" do
    it "returns the full representation of the block" do
      full_representation = BlockSerializer.new(block).full_representation
      
      expect(full_representation.except("dgst")).to eq(payload)
      expect(full_representation["dgst"]).to eq(BlockDigest.new(block).hex)
    end
  end

  describe "#representation_for_digest" do
    it "returns the representation of the block needed for the digest" do
      expect(
        BlockSerializer.new(block).representation_for_digest
      ).to eq({
        "ver" => Block::CURRENT_VERSION,
        "prev_dgst" => "previous_digest",
        "nonce" => 12345,
        "chain_tweaks" => { "complexity" => 10 },
        "txs" => [
          {
            "dgst" => "tx_digest",
            "at" => "2024-01-01T00:00:00Z",
            "ins" => [],
            "outs" => [],
            "wits" => []
          }
        ]
      })
    end
  end
end
