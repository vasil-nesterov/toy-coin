# typed: strict

class BlockSerializer
  extend T::Sig

  sig { params(payload: T::Hash[String, T.untyped]).returns(Block) }
  def self.from_representation(payload)
    Block.new(
      ver: payload["ver"],
      prev_dgst: payload["prev_dgst"],
      nonce: payload["nonce"],
      chain_tweaks: ChainTweaks.from_representation(payload["chain_tweaks"]),
      txs: payload["txs"].map { |tx| TxSerializer.from_representation(tx) }
    )
  end

  sig { params(block: Block).void }
  def initialize(block)
    @block = T.let(block, Block)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def full_representation
    { 
      "dgst" => BlockDigest.new(@block).hex 
    }.merge(representation_for_digest)
  end
  
  # TODO: put digest of all txs in header, not the whole payload
  sig { returns(T::Hash[String, T.untyped]) }
  def representation_for_digest
    {
      "ver" => @block.ver,
      "prev_dgst" => @block.prev_dgst,
      "nonce" => @block.nonce,
      "chain_tweaks" => @block.chain_tweaks&.to_representation,
      "txs" => @block.txs.map { |tx| TxSerializer.new(tx).full_representation }
    }.compact
  end
end
