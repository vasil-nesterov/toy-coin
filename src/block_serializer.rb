# typed: strict

class BlockSerializer
  extend T::Sig

  sig { params(block: Block).void }
  def initialize(block)
    @block = T.let(block, Block)
  end

  # TODO: rename to #serialize, or to #to_attributes
  sig { returns(T::Hash[String, T.untyped]) }
  def full_hash
    {
      ver: @block.version,
      dgst: BlockDigest.new(@block).hex,
      prev_dgst: @block.prev_dgst,
      nonce: @block.nonce,
      chain_tweaks: @block.chain_tweaks,
      sig_txs: @block.sig_txs.map(&:to_hash)
    }.compact
  end

  # TODO: put digest of sig_txs in header, not the whole payload
  sig { returns(T::Hash[String, T.untyped]) }
  def header_hash
    {
      ver: @block.version,
      prev_dgst: @block.prev_dgst,
      nonce: @block.nonce,
      chain_tweaks: @block.chain_tweaks,
      sig_txs: @block.sig_txs.map(&:to_hash)
    }.compact
  end
end
