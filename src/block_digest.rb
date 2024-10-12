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

  sig { returns(T::Hash[String, T.untyped]) }
  def block_header
    BlockSerializer.new(@block).header_hash.slice(*%w[
      ver
      prev_dgst
      nonce
      chain_tweaks
      sig_txs
    ])
  end
end
