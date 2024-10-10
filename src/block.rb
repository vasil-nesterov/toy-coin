# typed: strict

require "digest"
require "json"
require "sorbet-runtime"
require "time"

class Block < T::Struct
  InvalidBlockError = Class.new(StandardError)

  extend T::Sig

  prop :index, Integer
  prop :timestamp, Time
  prop :proof, Integer
  prop :transactions, T::Array[Transaction], default: []
  prop :previous_block_digest, String

  sig { returns(Block) }
  def self.new_genesis
    new(
      index: 0,
      timestamp: Time.now,
      proof: 0,
      transactions: [],
      previous_block_digest: ""
    )
  end

  sig { params(payload: T::Hash[String, T.untyped]).returns(Block) }
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

  sig { params(other: Block).returns(T::Boolean) }
  def ==(other)
    other.is_a?(Block) && to_h == other.to_h
  end

  sig { returns(String) }
  def digest
    Digest::SHA256.hexdigest(to_json)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    serialize.merge("timestamp" => timestamp.utc.iso8601)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h_with_digest
    to_h.merge("digest" => digest)
  end

  sig { returns(String) }
  def to_json
    h_with_stable_keys = to_h.sort.to_h
    JSON.generate(h_with_stable_keys)
  end
end
