# typed: strict

require "digest/blake3"
require "ed25519"
require "sorbet-runtime"

# Node doesn't expose Blockchain and Mempool directly, 
#   except #to_h method to visualize the state
class Node
  extend T::Sig

  sig { params(blockchain_storage: BlockchainStorage).void }
  def initialize(blockchain_storage:)
    @blockchain_storage = blockchain_storage
    @blockchain = T.let(@blockchain_storage.load, Blockchain)
    @mempool = T.let(Mempool.new, Mempool)
    # TODO: @utxo_pool = T.let(UTXOPool.new, UTXOPool)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    {
      "mempool" => @mempool.serialize,
      "blockchain" => @blockchain.serialize.reverse
    }
  end

  # sig { params(address: String).returns(Float) }
  # def balance(address)
  #   @balance_registry.balance(address)
  # end

  # sig { params(transaction: Transaction).returns(T::Boolean) }
  # def add_transaction_to_mempool(transaction)
  #   result = @mempool.add_transaction(transaction)

  #   if result
  #     @balance_registry.process_transaction(transaction)
  #   end

  #   result
  # end

  sig { params(block: Block).void }
  def add_block(block)
    @blockchain.add_block(block)
    @blockchain_storage.save(@blockchain) if ENV["PERSIST_BLOCKCHAIN"] == "true"

    # @balance_registry = @blockchain.balance_registry.deep_clone
    #Node should remove block.txs from mempool during Node#add_block
  end

  # Interface used by Miner. TODO: Find a better way to organize this
  sig { returns(Integer) }
  def blockchain_complexity
    @blockchain.current_complexity
  end

  sig { returns(String) }
  def last_block_dgst
    @blockchain.last_block_dgst
  end
end
