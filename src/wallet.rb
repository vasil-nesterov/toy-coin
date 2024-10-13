# typed: strict

# Wallet is initialized with a private key, and is responsible for:
#   - Checking the balance
#   - Sending coins 
# Adding to mempool is Node's responsibility

class Wallet
  extend T::Sig

  MINER_IDLE = T.let("idle".freeze, String)
  MINER_RUNNING = T.let("running".freeze, String)

  sig { params(node: Node, private_key: PrivateKey).void }
  def initialize(node:, private_key:)
    @node = node
    @private_key = private_key
    @public_key = T.let(private_key.public_key, PublicKey)
    
    @miner = T.let(nil, T.nilable(Thread))
  end


  sig { returns(Thread) }
  def mine_next_block
    raise "Miner is already running" if miner_status == MINER_RUNNING

    @miner = Thread.new do
      # TODO: Save the key to a file. Later on, add Keychain abstraction over a group of private keys
      next_block, _coinbase_private_key = Miner.new(
        complexity: @node.blockchain_complexity,
        last_block_dgst: @node.last_block_dgst,
        public_key: @public_key
      ).next_block

      @node.add_block(next_block)
    end
  end

  sig { returns(T::Hash[String, T.untyped]) } 
  def to_h
    {
      # address: address,
      # balance: balance,
      miner_status: miner_status
    }
  end

  private


  sig { returns(String) }
  def miner_status
    if @miner&.alive?
      MINER_RUNNING
    else
      MINER_IDLE
    end
  end
end
