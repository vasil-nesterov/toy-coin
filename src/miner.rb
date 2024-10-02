# typed: strict

class Miner
  extend T::Sig

  sig { params(blockchain: Blockchain, mempool: Mempool, coinbase_address: String).void }
  def initialize(blockchain:, mempool:, coinbase_address:)
    @blockchain = blockchain
    @mempool = mempool
    @coinbase_address = coinbase_address
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
      recipient: @coinbase_address,
      value: 1
    )

    @mempool.add_transaction(tx)
  end
end