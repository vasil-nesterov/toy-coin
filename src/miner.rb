# typed: strict
 
# Miner's responsibilities:
# - Build the next block
# - [TODO] Fetch N htxs from mempool ordered by priority DESC
# - [TODO] Create a new private key for the coinbase tx output
# - [TODO] Replace dest_pub with dest_pub_dgst
class Miner
  # In the formula below, 32 is the number of bytes.
  MAX_AVAILABLE_PROOF = T.let((2 ** (32 * 8)).to_i, Integer)

  extend T::Sig

  sig { 
    params(
      complexity: Integer, 
      last_block_dgst: String, 
      public_key: PublicKey
    ).void 
  }
  def initialize(complexity:, last_block_dgst:, public_key:)
    @complexity = complexity
    @last_block_dgst = last_block_dgst
    @public_key = public_key
  end

  sig { params(chain_tweaks: T.nilable(ChainTweaks)).returns(Block) }
  def next_block(chain_tweaks: nil)
    block = build_new_block
    block.chain_tweaks = chain_tweaks if chain_tweaks

    loop do
      block.nonce = rand(MAX_AVAILABLE_PROOF)

      break if BlockDigestSatisfiesComplexity.new(
        block:, 
        complexity: @complexity
      ).satisfied?
    end

    block
  end

  private

  sig { returns(Block) }
  def build_new_block
    Block.new(
      ver: Block::CURRENT_VERSION,
      prev_dgst: @last_block_dgst,
      nonce: 0,
      txs: [build_coinbase_tx]
    )
  end

  sig { returns(Tx) }
  def build_coinbase_tx
    out = Out.new(
      dest_pub: @public_key.hex,
      millis: 1_000 # TODO: A better logic
    )

    tx = Tx.new(
      dgst: '',
      at: Time.now.utc,
      ins: [],
      outs: [out],
      wits: []
    )

    tx.dgst = TxDigest.new(tx).hex
    tx
  end
end
