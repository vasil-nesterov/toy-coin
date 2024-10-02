# typed: strict

require "ed25519"
require "sorbet-runtime"

class Key
  extend T::Sig

  class << self
    extend T::Sig

    sig { params(path: String).returns(Key) }
    def load_or_init_from_file(path)
      if File.exist?(path)
        load_from_file(path)
      else
        new(
          Ed25519::SigningKey.generate.to_bytes.to_hex
        ).tap { |key| File.write(path, key.to_hex) }
      end
    end

    sig { params(path: String).returns(Key) }
    def load_from_file(path)
      hex = File.read(path)
      new(hex)
    end
  end

  sig { params(private_key: String).void }
  def initialize(private_key)
    @private_key = T.let(Ed25519::SigningKey.new(private_key.to_bytes), Ed25519::SigningKey)
    @public_key = T.let(@private_key.verify_key, Ed25519::VerifyKey)
  end

  sig { returns(String) }
  def to_hex
    @private_key.to_bytes.to_hex
  end

  sig { returns(String) }
  def address
    @public_key.to_bytes.to_hex
  end
end
