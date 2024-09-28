require "digest"
require "dry-struct"
require "json"
require "time"

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

  def ==(other)
    other.is_a?(Block) && to_h == other.to_h
  end

  def digest
    Digest::SHA256.hexdigest(to_json)
  end

  def to_h
    super.merge(timestamp: timestamp.utc.iso8601)
  end

  def to_json
    to_h
      .sort.to_h # Sort keys to make JSON stable
      .then { JSON.generate(_1) }
  end
end
