# typed: strict

class KeyStorage
  extend T::Sig

  sig { params(path: String).void }
  def initialize(path)
    @path = path
    @kv_storage = T.let(KVStorage.new(path), KVStorage)
  end

  sig { returns({private_key: PrivateKey, public_key: PublicKey}) }
  def read
    secret_hex, public_hex = @kv_storage
      .read
      .fetch_values('SECRET', 'PUBLIC')

    # TODO: Return KeyPair, not a loosely typed hash
    {
      private_key: PrivateKey.new(secret_hex),
      public_key: PublicKey.new(public_hex)
    }
  end

  sig { params(private_key: PrivateKey).void }
  def write(private_key)
    @kv_storage.write({
      'SECRET' => private_key.hex,
      'PUBLIC' => private_key.public_key.hex
    })
  end
end   
