# typed: false

require "digest"
require "json"
require "sorbet-runtime"
require "time"

class Block < T::Struct
  InvalidBlockError = Class.new(StandardError)

  prop :index, Integer
  prop :timestamp, Time
  prop :proof, Integer
  prop :transactions, T::Array[Transaction], default: []
  prop :previous_block_digest, String

  def self.new_genesis
    new(
      index: 0,
      timestamp: Time.now,
      proof: 0,
      transactions: [],
      previous_block_digest: ""
    )
  end

  def self.from_h(payload)
    index, timestamp, proof, transactions, previous_block_digest = payload.values_at(
      "index", "timestamp", "proof", "transactions", "previous_block_digest"
    )

    new(
      index:,
      timestamp: Time.parse(timestamp),
      proof:,
      transactions: transactions.map { |t| Transaction.from_hash(t) },
      previous_block_digest:
    )
  end

  def ==(other)
    other.is_a?(Block) && to_h == other.to_h
  end

  def digest
    Digest::SHA256.hexdigest(to_json)
  end

  def to_h
    serialize.merge("timestamp" => timestamp.utc.iso8601)
  end

  def to_h_with_digest
    to_h.merge("digest" => digest)
  end

  def to_json
    h_with_stable_keys = to_h.sort.to_h
    JSON.generate(h_with_stable_keys)
  end
end
