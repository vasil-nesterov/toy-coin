# typed: strict

require 'digest/blake3'
require 'ed25519'
require 'json'
require 'sorbet-runtime'

class Transaction < T::Struct
  extend T::Sig

  prop :sender, String
  prop :recipient, String
  prop :value, Float
  prop :signature, T.nilable(String)

  # WHY: .from_hash from Sorbet doesn't do type checking, which is far from ideal
  # TODO: Try out https://github.com/maxveldink/sorbet-schema
  sig { params(payload: T::Hash[String, T.untyped]).returns(Transaction) }
  def self.from_hash(payload)
    sender, recipient, value, signature = payload.values_at('sender', 'recipient', 'value', 'signature')
    new(sender:, recipient:, value:, signature:)
  end

  sig { params(recipient: String, value: Float).returns(Transaction) }
  def self.new_coinbase(recipient:, value:)
    new(
      sender: "0",
      recipient: recipient,
      value: value
    )
  end

  sig { returns(String) }
  def id
    Digest::Blake3.hexdigest(id_payload)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    serialize
      .sort
      .to_h # Stabilize output
  end

  sig { returns(T::Boolean) }
  def coinbase?
    sender == "0"
  end

  sig { returns(T::Boolean) }
  def has_valid_signature?
    # TODO: return true if coinbase?
    signature_bytes = signature&.to_bytes # https://sorbet.org/docs/flow-sensitive#limitations-of-flow-sensitivity
    return false unless signature_bytes

    public_key =
      if coinbase?
        recipient
      else
        sender
      end

    public_key = Ed25519::VerifyKey.new(public_key.to_bytes)
    public_key.verify(signature_bytes, id)
  rescue Ed25519::VerifyError
    false 
  end

  sig { params(key: Key).void }
  def sign_with_key(key)
    self.signature = key.sign(id)
  end

  private 
  
  sig { returns(String) }
  def id_payload
    to_h
      .slice('sender', 'recipient', 'value')
      .then { JSON.dump(_1) }
  end
end