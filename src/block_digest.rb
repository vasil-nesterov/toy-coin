# typed: strict

class BlockDigest
  extend T::Sig

  sig { params(block: Block).void }
  def initialize(block)
    @block = block
  end

  sig { returns(String) }
  def hex
    Digest::Blake3.hexdigest(payload)
  end

  sig { returns(String) }
  def payload
    BlockSerializer
      .new(@block)
      .representation_for_digest
      .to_stable_json
  end
end
