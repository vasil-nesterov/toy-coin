# typed: false

describe BlockDigest do
  let(:block) do
    Block.new(
      version: Block::CURRENT_VERSION,
      prev_dgst: "previous_digest",
      nonce: 12345,
      chain_tweaks: { "complexity" => 1 },
      sig_txs: []
    )
  end

  describe "#hex" do
    it "returns a hexadecimal digest of the block header" do
      digest = BlockDigest.new(block)
      expect(digest.hex).to eq('6e46dd10defc9b56c29a6ec56b508c21f54c08192194e4df25bf36f0c9c3c279')
    end
  end
end
