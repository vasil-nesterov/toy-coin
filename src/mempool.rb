# typed: strict

class Mempool
  extend T::Sig

  sig { void }
  def initialize
    @txs = T.let([], T::Array[Tx])
  end

  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def to_representation
    @txs.map { TxSerializer.new(_1).full_representation }
  end

  sig { params(tx: Tx).void }
  def add_tx(tx)
    @txs << tx
  end
end