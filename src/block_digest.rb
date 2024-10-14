# typed: strict

require 'digest/blake3'

class BlockDigest
  extend T::Sig

  sig { params(block: Block).void }
  def initialize(block)
    @block = block
  end

  sig { returns(String) }
  def hex
    Digest::Blake3.hexdigest(block_header.to_stable_json)
  end

  private

  # TODO: a better name
  sig { returns(T::Hash[String, T.untyped]) }
  def block_header
    BlockSerializer
      .new(@block)
      .representation_for_digest
  end
end
