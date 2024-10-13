# typed: strict
 
# Miner's responsibilities:
# - Build the next block
# - Return [block, private-key-for-coinbase-tx-output]
class Miner
  extend T::Sig

  sig { params(complexity: Integer, last_block_dgst: String).void }
  def initialize(complexity:, last_block_dgst:)
    # TODO: Fetch N high-priority txs from mempool
    @complexity = complexity
    @last_block_dgst = last_block_dgst

    @coinbase_private_key = T.let(Key.generate, Key)
  end

  sig { params(chain_tweaks: T.nilable(T::Hash[Symbol, T.untyped])).returns([Block, Key]) }
  def next_block(chain_tweaks: nil)
    # TODO: Add N txs to the block
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

    [block, @coinbase_private_key]
  end

  private

  sig { returns(Tx) }
  def coinbase_tx
    out = Out.new(
      dest_pub: @coinbase_private_key.public_hex,
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