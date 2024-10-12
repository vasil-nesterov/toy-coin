# typed: strict

# TODO: Miner shouldn't wipe mempool. Node should remove block.txs from mempool during Node#add_block
# TODO: Miner doesn't need a private_key. Coinbase tx shouldn't be signed.
# 
# Miner's responsibilities
# - Find the next proof
# - Build a new block with transactions from mempool
# - Send new block to Node
# 
# Can Miner get everything it needs from Node?
# - Last block
# - Complexity
# - Mempool
class Miner
  extend T::Sig

  sig { params(blockchain: Blockchain, mempool: Mempool, enforce_complexity: T.nilable(Integer)).void }
  def initialize(blockchain:, mempool:, enforce_complexity: nil)
    @blockchain = blockchain
    @mempool = mempool
    
    @coinbase_signing_key = T.let(Key.generate, Key)
  end

  sig { params(chain_tweaks: T.nilable(T::Hash[Symbol, T.untyped])).returns(Block) }
  def next_block(chain_tweaks: nil)
    block = Block.new(
      version: Block::CURRENT_VERSION,
      prev_dgst: @blockchain.last_block_dgst,
      nonce: 0,
      sig_txs: [] # TODO: Add coinbase tx
    )

    # TODO: Refactor
    if chain_tweaks
      block.chain_tweaks = chain_tweaks
    end

    complexity = 
      if chain_tweaks && chain_tweaks[:complexity]
        chain_tweaks[:complexity]
      else
        @blockchain.current_complexity
      end

    loop do
      block.nonce += 1
      hex = BlockDigest.new(block).hex
    
      break if hex.start_with?("0" * complexity)
    end

    block
  end

  # sig { returns(SigTx) }
  # def coinbase_tx
  #   out = Out.new(
  #     dest_pub: # TODO: generate a new key and return it alongside block
  #     millis: 1_000 # TODO: A better logic
  #   )

  #   tx = Tx.new(
  #     dgst: '',
  #     at: Time.now.utc,
  #     ins: [],
  #     outs: [out]
  #   )

  #   SigTx.new(
  #     tx:, 
  #     in_sigs: []
  #   )
  # end

  # sig { void }
  # def mine_next_block
  #   new_block_proof = ProofOfWork.new(@node.complexity).next_proof(@node.last_block.proof)

  #   add_coinbase_tx

  #   new_block = Block.new(
  #     index: @node.last_block.index + 1,
  #     timestamp: Time.now.utc,
  #     proof: new_block_proof,
  #     transactions: @node.mempool.wipe,
  #     previous_block_digest: @node.last_block.digest
  #   )
    
  #   @node.add_block(new_block)
  # end

  # sig { void }
  # def add_coinbase_tx
  #   tx = Transaction.new(
  #     sender: "0",
  #     recipient: @private_key.address,
  #     value: 1.0
  #   )
  #   tx.sign_with_key(@private_key)

  #   @node.add_transaction_to_mempool(tx)
  # end
end