# typed: true

class Miner
  extend T::Sig

  sig { params(blockchain: Blockchain, mempool: Mempool).void }
  def initialize(blockchain:, mempool:)
    @blockchain = blockchain
    @mempool = mempool
  end

  sig { void }
  def mine_next_block
    last_block = @blockchain.last_block
    new_block_proof = ProofOfWork.new(@blockchain.complexity).next_proof(last_block.proof)

    new_block = Block.new(
      index: last_block.index + 1,
      timestamp: Time.now.utc,
      proof: new_block_proof,
      transactions: @mempool.wipe,
      previous_block_digest: last_block.digest
    )

    @blockchain.add_block(new_block)
  end
end