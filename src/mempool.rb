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

  # WIP: Ensure that tx is valid
  sig { params(tx: Tx).returns(T::Boolean) }
  def add_tx(tx)
    @txs << tx

    true
  end
end