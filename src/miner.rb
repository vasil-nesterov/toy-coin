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

  sig { params(node: Node, private_key: Key).void }
  def initialize(node:, private_key:)
    @node = node
    @private_key = private_key
  end

  sig { void }
  def mine_next_block
    new_block_proof = ProofOfWork.new(@node.complexity).next_proof(@node.last_block.proof)

    add_coinbase_tx

    new_block = Block.new(
      index: @node.last_block.index + 1,
      timestamp: Time.now.utc,
      proof: new_block_proof,
      transactions: @node.mempool.wipe,
      previous_block_digest: @node.last_block.digest
    )
    
    @node.add_block(new_block)
  end

  sig { void }
  def add_coinbase_tx
    tx = Transaction.new(
      sender: "0",
      recipient: @private_key.address,
      value: 1.0
    )
    tx.sign_with_key(@private_key)

    @node.add_transaction_to_mempool(tx)
  end
end