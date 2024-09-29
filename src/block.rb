require "digest"
require "dry-struct"
require "dry-validation"
require "json"
require "time"

class Block < Dry::Struct
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

  attribute :index, Types::Integer
  attribute :timestamp, Types::Time
  attribute :proof, Types::Integer
  attribute :transactions, Types::Array.of(Transaction)
  attribute :previous_block_digest, Types::String

  def self.genesis # TODO: rename to .new_genesis
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
      new(validation_result.to_h)
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

  def to_h_with_digest
    to_h.merge(digest: digest)
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
