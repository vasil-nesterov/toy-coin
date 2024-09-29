class Miner
  def initialize(blockchain:)
    @blockchain = blockchain
  end

  def mine_next_block(mempool:)
    last_block = @blockchain.last_block
    new_block_proof = ProofOfWork.new(@blockchain.complexity).next_proof(last_block.proof)

    new_block = Block.new(
      index: last_block.index + 1,
      timestamp: Time.now.utc,
      proof: new_block_proof,
      transactions: mempool.wipe,
      previous_block_digest: last_block.digest
    )

    @blockchain.add_block(new_block)
  end
end