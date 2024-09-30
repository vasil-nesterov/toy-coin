# typed: false
require "digest"
require "dry-validation"
require "json"
require "sorbet-runtime"
require "time"

class Block < T::Struct
  InvalidBlockError = Class.new(StandardError)

  class Contract < Dry::Validation::Contract
    json do
      required(:index).filled(:integer).value(gteq?: 0)
      required(:timestamp).filled(:time)
      required(:proof).filled(:integer).value(gteq?: 0)
      required(:transactions).value(:array).each do
        hash(Transaction::Contract.new.schema)
      end
      required(:previous_block_digest).value(:string)
    end
  end

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

  def self.from_h(hash)
    validation_result = Contract.new.call(hash)

    if validation_result.success?
      validation_result.to_h.then do |hash|
        hash[:transactions] = hash[:transactions]&.map { |t| Transaction.from_h(t) }
        new(hash)
      end
    else
      raise InvalidBlockError, "Invalid block: #{hash}, errors: #{validation_result.errors.to_h}"
    end
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
