# typed: strict

class Mempool
  extend T::Sig

  sig { void }
  def initialize
    @txs = T.let([], T::Array[Tx])
  end

  # TODO: consistent naming. Serialize everywhere.
  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def serialize
    @txs.map { _1.to_hash }
  end

  # sig { params(transaction: Transaction).returns(T::Boolean) }
  # def add_transaction(transaction)
  #   if TransactionValidator.new(transaction).call
  #     @transactions << transaction
  #     true
  #   else
  #     false
  #   end
  # end
end