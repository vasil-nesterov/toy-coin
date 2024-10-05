# typed: strict

require "digest/blake3"
require "ed25519"
require "sorbet-runtime"

# Node exposes Blockchain and Mempool only for visualization purpose,
# Everything else should be done through Node methods.
class Node
  extend T::Sig

  MINER_IDLE = T.let("idle".freeze, String)
  MINER_RUNNING = T.let("running".freeze, String)

  sig { params(node_name: String, blockchain_storage: BlockchainStorage, private_key: Key).void }
  def initialize(node_name:, blockchain_storage:, private_key:)
    @node_name = node_name
    @private_key = private_key

    @blockchain_storage = blockchain_storage
    @blockchain = T.let(@blockchain_storage.load_or_init, Blockchain)
    @mempool = T.let(Mempool.new, Mempool)

    @miner = T.let(nil, T.nilable(Thread))
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    {
      node_name: @node_name,
      address: @private_key.address,
      miner: miner_status,
      mempool: @mempool.to_h,
      blockchain: @blockchain.to_h.tap { |h| h[:blocks].reverse! }
    }
  end

  sig { params(address: String).returns(Float) }
  def balance(address)
    @blockchain.balance_registry.balance(address)
  end

  sig { params(transaction: Transaction).returns(T::Boolean) }
  def add_transaction_to_mempool(transaction)
    @mempool.add_transaction(transaction)
  end

  sig { returns(String) }
  def miner_status
    if @miner&.alive?
      MINER_RUNNING
    else
      MINER_IDLE
    end
  end

  sig { returns(Thread) }
  def mine_next_block
    raise "Miner is already running" if miner_status == MINER_RUNNING

    @miner = Thread.new do
      Miner.new(blockchain: @blockchain, mempool: @mempool, private_key: @private_key).mine_next_block
      # TODO: move BS.save to miner
      @blockchain_storage.save(@blockchain) if ENV["PERSIST_BLOCKCHAIN"] == "true"
    end
  end
end
