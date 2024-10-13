# typed: strict

# Wallet is initialized with a private key, and is responsible for:
#   - Checking the balance
#   - Sending coins 
# Adding to mempool is Node's responsibility

# TODO: Wallet should connect to Node via HTTP
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

  # sig { params(recipient_address: String, millis: Integer).void }
  # def send_coins(recipient_address:, millis:)
  #   # Take outs that belong to this wallet, until outs.sum(:millis) < amount_to_send
  #   # Create a tx with 
  #   #   - inputs: these outs
  #   #   - outputs: (1) recipient_address + (2) the rest of the outs back to this wallet
  #   #   - sign inputs with this wallet's key
  #   @node.process_tx(tx)
  # end

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
    { address:, balance:, miner_status: }
  end

  private

  sig { returns(String) }
  def address
    @public_key.hex
  end

  sig { returns(Integer) }
  def balance
    @node.balance_for(@public_key.hex)
  end

  sig { returns(String) }
  def miner_status
    if @miner&.alive?
      MINER_RUNNING
    else
      MINER_IDLE
    end
  end
end
