# typed: false

require 'digest/blake3'
require 'ed25519'
require 'dry-validation'
require 'json'
require 'sorbet-runtime'

class Transaction < T::Struct
  extend T::Sig

  class Contract < Dry::Validation::Contract
    json do
      required(:sender).filled(:string)
      required(:recipient).filled(:string)
      required(:value).filled(:float, gt?: 0)
    end
  end

  prop :sender, String
  prop :recipient, String
  prop :value, Float

  prop :signature, T.nilable(String)

  def self.new_coinbase(recipient:, value:)
    new(
      sender: "0",
      recipient: recipient,
      value: value
    )
  end

  def id
    Digest::Blake3.hexdigest(id_payload)
  end

  def to_h
    serialize      
      .sort      
      .to_h # Stabilize output
  end

  def coinbase?
    sender == "0"
  end

  def has_valid_signature?
    # TODO: return true if coinbase?
    return false unless signature

    public_key =
      if coinbase?
        recipient
      else
        sender
      end

    public_key = Ed25519::VerifyKey.new(public_key.to_bytes)
    public_key.verify(signature.to_bytes, id)
  rescue Ed25519::VerifyError
    false 
  end

  sig { params(key: Key).void }
  def sign_with_key(key)
    self.signature = key.sign(id)
  end

  private 
  
  def id_payload
    to_h
      .slice('sender', 'recipient', 'value')
      .then { JSON.dump(_1) }
  end
end