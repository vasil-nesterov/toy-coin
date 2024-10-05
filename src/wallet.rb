# typed: strict

# Wallet is initialized with a private key, and is responsible for:
#   - Checking the balance
#   - Sending coins 
# Adding to mempool is Node's responsibility

class Wallet
  extend T::Sig

  MINER_IDLE = T.let("idle".freeze, String)
  MINER_RUNNING = T.let("running".freeze, String)

  sig { params(node: Node, key: Key).void }
  def initialize(node:, key:)
    @node = node
    @key = key

    @miner = T.let(nil, T.nilable(Thread))
  end

  sig { params(recipient_address: String, amount: Float).void }
  def send_coins(recipient_address, amount)
    tx = Transaction.new(
      sender: @key.address, 
      recipient: recipient_address,
      value: amount
    )
    tx.sign_with_key(@key)

    @node.add_transaction_to_mempool(tx)
  end

  sig { returns(Thread) }
  def mine_next_block
    raise "Miner is already running" if miner_status == MINER_RUNNING

    @miner = Thread.new do
      Miner.new(node: @node, private_key: @key).mine_next_block
    end
  end

  sig { returns(Float) }
  def balance
    @node.balance(@key.address)
  end

  sig { returns(T::Hash[String, T.untyped]) } 
  def to_h
    {
      address: address,
      balance: balance,
      miner_status: miner_status
    }
  end

  private

  sig { returns(String) }
  def address
    @key.address
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
