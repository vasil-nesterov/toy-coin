# typed: true

require "digest/blake3"
require "ed25519"
require "sorbet-runtime"

# Node exposes Blockchain and Mempool only for visualization purpose,
# Everything else should be done through Node methods.
class Node
  extend T::Sig

  MINER_IDLE = "idle".freeze
  MINER_RUNNING = "running".freeze

  sig { params(node_name: String, blockchain_storage: BlockchainStorage).void }
  def initialize(node_name:, blockchain_storage:)
    @node_name = node_name
    @mempool = Mempool.new 

    @blockchain_storage = blockchain_storage
    @blockchain = @blockchain_storage.load_or_init

    @miner = nil

    @key = Key.load_or_init_from_file("#{ROOT_DIR}/data/keys/#{@node_name}.key")
  end

  def to_h
    {
      node_name: @node_name,
      address: @key.address,
      miner: miner_status,
      mempool: @mempool.to_h,
      blockchain: @blockchain.to_h
    }
  end

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

  def mine_next_block
    raise "Miner is already running" if miner_status == MINER_RUNNING

    @miner = Thread.new do
      Miner.new(blockchain: @blockchain, mempool: @mempool, coinbase_address: @key.address).mine_next_block
      # TODO: move BS.save to miner
      @blockchain_storage.save(@blockchain) if ENV["PERSIST_BLOCKCHAIN"] == "true"
    end
  end
end
