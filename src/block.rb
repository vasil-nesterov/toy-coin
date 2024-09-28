require "time"
require "dry-struct"

class Block < Dry::Struct
  attribute :index, Types::Integer
  attribute :timestamp, Types::Time
  attribute :proof, Types::Integer
  attribute :transactions, Types::Array.of(Types::Hash)
  attribute :previous_block_digest, Types::String

  def self.genesis
    new(
      index: 0,
      timestamp: Time.now,
      proof: 0,
      transactions: [],
      previous_block_digest: ""
    )
  end

  def as_json
    to_h.merge(timestamp: timestamp.utc.iso8601)
  end

  def ==(other)
    other.is_a?(Block) && as_json == other.as_json
  end
end
