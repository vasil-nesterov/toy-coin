# typed: strict

class Mempool
  extend T::Sig

  sig { void }
  def initialize
    @transactions = T.let([], T::Array[Transaction])
  end

  sig { params(transaction: Transaction).returns(T::Boolean) }
  def add_transaction(transaction)
    if TransactionValidator.new(transaction).call
      @transactions << transaction
      true
    else
      false
    end
  end

  sig { returns(T::Array[Transaction]) }
  def wipe
    @transactions.tap { @transactions = [] }
  end

  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def to_h
    @transactions.map(&:to_h)
  end
end