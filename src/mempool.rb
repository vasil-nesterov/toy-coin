# typed: true
class Mempool
  def initialize
    @transactions = []
  end

  def add_transaction(transaction)
    @transactions << transaction
  end

  def wipe
    result = @transactions
    @transactions = []

    result
  end

  def to_h
    @transactions.map(&:to_h)
  end
end