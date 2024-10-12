# typed: strict

class PublicKey
  extend T::Sig

  sig { params(hex: String).void }
  def initialize(hex)
    @vk = T.let(Ed25519::VerifyKey.new(hex.to_bytes), Ed25519::VerifyKey)
  end

  sig { params(signature: String, data: String).returns(T::Boolean) }
  def verify(signature, data)
    @vk.verify(signature.to_bytes, data)
  rescue Ed25519::VerifyError
    false
  end
end