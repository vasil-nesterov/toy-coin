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
    blockchain, utxo_set = @blockchain_storage.load

    @blockchain = T.let(blockchain, Blockchain)
    @utxo_set = T.let(utxo_set, UTXOSet)  

    @mempool = T.let(Mempool.new, Mempool)
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    {
      "mempool" => @mempool.serialize,
      "utxos" => @utxo_set.serialize,
      # TODO: Move to BlockchainSerializer#pretty_serialize
      "blockchain" => @blockchain.serialize.map.with_index { |block_hash, i| {"height" => i}.merge(block_hash) }.reverse
    }
  end

  sig { params(block: Block).void }
  def add_block(block)
    @blockchain.add_block(block)
    @blockchain_storage.save(@blockchain) if ENV["PERSIST_BLOCKCHAIN"] == "true"

    # TODO: Remove block.txs from mempool
    @utxo_set.process_block(block)
  end

  # sig { params(transaction: Transaction).returns(T::Boolean) }
  # def add_transaction_to_mempool(transaction)
  #   result = @mempool.add_transaction(transaction)

  #   if result
  #     @balance_registry.process_transaction(transaction)
  #   end

  #   result
  # end

  # Interface for Wallet
  sig { params(address: String).returns(Integer) }
  def balance_for(address)
    @utxo_set.balance_for(address)
  end

  # Interface for Miner. TODO: Find a better way to organize this
  sig { returns(Integer) }
  def blockchain_complexity
    @blockchain.current_complexity
  end

  sig { returns(String) }
  def last_block_dgst
    @blockchain.last_block_dgst
  end
end
