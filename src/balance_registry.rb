# typed: strict

# TODO: replace with UTXO
class BalanceRegistry
  class SenderHasNotEnoughCoinsError < StandardError; end

  extend T::Sig

  sig { returns(T::Hash[String, Float]) }
  attr_reader :balances

  sig { params(initial_balances: T::Hash[String, Float]).void }
  def initialize(initial_balances: {})
    @balances = initial_balances
  end

  sig { returns(BalanceRegistry) }
  def deep_clone
    BalanceRegistry.new(initial_balances: @balances.dup)
  end

  sig { params(address: String).returns(Float) }
  def balance(address)
    @balances[address] || 0.0
  end

  sig { returns(T::Hash[String, Float]) }
  def to_h
    @balances
  end

  sig { params(block: Block).void }
  def process_block(block)
    block.transactions.each { process_transaction(_1) }
  end

  sig { params(tx: Transaction).void }
  def process_transaction(tx)
    remove_coins_from_sender(tx) unless tx.coinbase?
    add_coins_to_recipient(tx)
  end

  private

  sig { params(tx: Transaction).void }
  def add_coins_to_recipient(tx)
    @balances[tx.recipient] = balance(tx.recipient) + tx.value
  end

  sig { params(tx: Transaction).void }
  def remove_coins_from_sender(tx)
    if balance(tx.sender) >= tx.value
      @balances[tx.sender] = balance(tx.sender) - tx.value
    else
      msg = "Sender's balance: #{balance(tx.sender)}, Tx: #{tx.inspect}"
      raise SenderHasNotEnoughCoinsError, msg
    end
  end
end