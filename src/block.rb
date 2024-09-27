require "time"

class Block
  attr_reader :index,
              :timestamp,
              :proof,
              :transactions,
              :previous_block_digest

  def self.genesis
    new(
      index: 0,
      timestamp: Time.now,
      proof: 0,
      transactions: [],
      previous_block_digest: ""
    )
  end

  def initialize(index:, timestamp:, proof:, transactions:, previous_block_digest:)
    @index = index
    @timestamp = timestamp
    @proof = proof
    @transactions = transactions
    @previous_block_digest = previous_block_digest
  end

  def as_json
    {
      "index" => @index,
      "timestamp" => @timestamp.utc.iso8601,
      "proof" => @proof,
      "transactions" => @transactions,
      "previous_block_digest" => @previous_block_digest
    }
  end

  def ==(other)
    other.is_a?(Block) &&
      as_json == other.as_json
  end
end
