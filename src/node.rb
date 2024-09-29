# Node exposes Blockchain and Mempool only for visualization purpose,
# Everything else should be done through Node methods.
class Node
  def initialize(blockchain_storage)
    @blockchain_storage = blockchain_storage
    @blockchain = @blockchain_storage.load_or_init

    @mempool = Mempool.new
  end

  def to_h
    {
      mempool: @mempool.to_h,
      blockchain: @blockchain.to_h
    }
  end

  def add_transaction_to_mempool(transaction)
    @mempool.add_transaction(transaction)
  end

  def mine_next_block
    miner = Miner.new(blockchain: @blockchain, complexity: 5)
    miner.mine_next_block(mempool: @mempool)
  end
end
