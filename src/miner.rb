# typed: strict

class Miner
  extend T::Sig

  sig { params(blockchain: Blockchain, mempool: Mempool, private_key: Key).void }
  def initialize(blockchain:, mempool:, private_key:)
    @blockchain = blockchain
    @mempool = mempool
    @private_key = private_key
  end

  sig { void }
  def mine_next_block
    last_block = @blockchain.last_block
    new_block_proof = ProofOfWork.new(@blockchain.complexity).next_proof(last_block.proof)

    add_coinbase_tx

    new_block = Block.new(
      index: last_block.index + 1,
      timestamp: Time.now.utc,
      proof: new_block_proof,
      transactions: @mempool.wipe,
      previous_block_digest: last_block.digest
    )

    @blockchain.add_block(new_block)
  end

  sig { void }
  def add_coinbase_tx
    tx = Transaction.new(
      sender: "0",
      recipient: @private_key.address,
      value: 1
    )
    tx.sign_with_key(@private_key)

    @mempool.add_transaction(tx)
  end
end