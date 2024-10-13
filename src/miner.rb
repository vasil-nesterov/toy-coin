# typed: strict
 
# Miner's responsibilities:
# - Build the next block
# - [TODO] Fetch N htxs from mempool ordered by priority DESC
# - [TODO] Create a new private key for the coinbase tx output
# - [TODO] Replace dest_pub with dest_pub_dgst
class Miner
  extend T::Sig

  sig { params(complexity: Integer, last_block_dgst: String, public_key: PublicKey).void }
  def initialize(complexity:, last_block_dgst:, public_key:)
    @complexity = complexity
    @last_block_dgst = last_block_dgst
    @public_key = public_key
  end

  sig { params(chain_tweaks: T.nilable(T::Hash[Symbol, T.untyped])).returns(Block) }
  def next_block(chain_tweaks: nil)
    block = Block.new(
      ver: Block::CURRENT_VERSION,
      prev_dgst: @last_block_dgst,
      nonce: 0,
      txs: [coinbase_tx]
    )

    # TODO: Refactor
    if chain_tweaks
      block.chain_tweaks = chain_tweaks
    end

    loop do
      block.nonce += 1
      break if BlockDigestSatisfiesComplexity.new(block: block, complexity: @complexity).satisfied?
    end

    block
  end

  private

  sig { returns(Tx) }
  def coinbase_tx
    out = Out.new(
      dest_pub: @public_key.hex,
      millis: 1_000 # TODO: A better logic
    )

    Tx.new(
      dgst: '',
      at: Time.now.utc,
      ins: [],
      outs: [out],
      wits: []
    )
  end
end