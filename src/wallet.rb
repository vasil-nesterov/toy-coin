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
end