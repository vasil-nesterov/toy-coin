# typed: false
require "rspec"

describe Block do
  let(:block) {
    Block.new(
      index: 1,
      timestamp: Time.parse("2024-05-01T00:00:00Z"),
      proof: 0,
      transactions: [],
      previous_block_digest: ""
    )
  }

  describe '#from_h' do
    it 'returns a new block' do
      expect(Block.from_h(block.to_h)).to eq(block)
    end
  end

  describe "#==" do
    let(:another_block) {
      Block.new(
        index: 2,
        timestamp: Time.parse("2024-06-01T00:00:00Z"),
        proof: 123,
        transactions: [],
        previous_block_digest: "abc123"
      )
    }

    it "returns true if the objects are the same" do
      expect(block == block.dup).to be(true)
    end

    it "returns false if the objects are different" do
      expect(block == another_block).to be(false)
    end
  end

  describe "#digest" do
    it "returns the digest of the block" do
      expect(block.digest).to eq("42dc56a11fa5ca53e309a6b90e232ca9ca8706801a2d4cfab3b967f066bb0a65")
    end
  end

  describe "#to_h" do
    it "returns a hash representation of the block" do
      expect(block.to_h).to eq(
        {
          'index' => 1,
          'timestamp' => '2024-05-01T00:00:00Z',
          'proof' => 0,
          'transactions' => [],
          'previous_block_digest' => '' 
        }
      )
    end 
  end

  describe "#to_h_with_digest" do
    it "returns a hash representation of the block with the digest" do
      expect(block.to_h_with_digest).to eq(
        {
          'index' => 1,
          'timestamp' => '2024-05-01T00:00:00Z',
          'proof' => 0,
          'transactions' => [],
          'previous_block_digest' => '',
          'digest' => '42dc56a11fa5ca53e309a6b90e232ca9ca8706801a2d4cfab3b967f066bb0a65'
        }
      )
    end
  end

  describe "#to_json" do
    it "returns a JSON representation of the block" do
      expect(block.to_json).to eq(<<~JSON.chomp
        {"index":1,"previous_block_digest":"","proof":0,"timestamp":"2024-05-01T00:00:00Z","transactions":[]}
      JSON
      )
    end
  end
end
