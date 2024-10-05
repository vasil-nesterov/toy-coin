# typed: strict

# Wallet is initialized with a private key, and is responsible for:
#   - Checking the balance
#   - Sending coins 
# Adding to mempool is Node's responsibility

class Wallet
  extend T::Sig

  sig { params(node: Node, key: Key).void }
  def initialize(node:, key:)
    @node = node
    @key = key
  end

  sig { returns(Float) }
  def balance
    @node.balance(@key.address)
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
end
