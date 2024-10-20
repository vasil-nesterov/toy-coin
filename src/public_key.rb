# typed: strict

# USAGE:
# 
# pk = PublicKey.new("92b843ffb0851e3275867396f215a7e6421846a53d4f8fc699d41bbc36dd791d")
# pk.verify_signature(
#   data: "herp-derp", 
#   signature: "abe47ab367ea23c7252c08a0b992ab5f6c53440d9456f5e29bf32c953b025aabb65b52239079856883788b28869c2b16e306bbf8616ce8345bc429b44edd560f"
# ) #=> true or false
# 
class PublicKey
  extend T::Sig

  sig { returns(String) }
  attr_reader :hex

  sig { params(hex: String).void }
  def initialize(hex)
    @hex = hex
    @vk = T.let(Ed25519::VerifyKey.new(hex.to_bytes), Ed25519::VerifyKey)
  end

  sig { params(data: String, signature: String).returns(T::Boolean) }
  def verify_signature(data:, signature:)
    @vk.verify(signature.to_bytes, data)
  rescue Ed25519::VerifyError
    false
  end
end
