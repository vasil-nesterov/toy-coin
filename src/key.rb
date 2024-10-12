# typed: strict

require 'ed25519'
require 'sorbet-runtime'

class Key
  extend T::Sig

  class << self
    extend T::Sig

    sig { params(path: String).returns(Key) }
    def load_from_file(path)
      hex = KVStorage.new(path).fetch('SECRET')
      new(hex)
    end

    sig { returns(Key) }
    def generate
      new(Ed25519::SigningKey.generate.to_bytes.to_hex)
    end
  end

  sig { params(secret_hex: String).void }
  def initialize(secret_hex)
    @secret_part = T.let(Ed25519::SigningKey.new(secret_hex.to_bytes), Ed25519::SigningKey)
    @public_part = T.let(@secret_part.verify_key, Ed25519::VerifyKey)
  end

  sig { params(data: String).returns(String) }
  def sign(data)
    @secret_part.sign(data).to_hex
  end

  sig { returns(String) }
  def secret_hex
    @secret_part.to_bytes.to_hex
  end

  sig { returns(String) }
  def public_hex
    @public_part.to_bytes.to_hex
  end
end
