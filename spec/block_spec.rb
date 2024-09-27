require "rspec"
require_relative "../src/block"

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

  describe "#as_json" do
    it "returns object as a hash" do
      expect(block.as_json).to eq({
        "index" => 1,
        "timestamp" => block.timestamp.utc.iso8601,
        "proof" => 0,
        "transactions" => [],
        "previous_block_digest" => ""
      })
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
      expect(block == block).to be(true)
    end

    it "returns false if the objects are different" do
      expect(block == another_block).to be(false)
    end
  end
end
