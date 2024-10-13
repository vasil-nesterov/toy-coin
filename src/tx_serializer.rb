# typed: strict

class TxSerializer
  extend T::Sig

  sig { params(tx: Tx).void }
  def initialize(tx)
    @tx = tx
  end

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def representation_for_digest
    {
      "at" => @tx.at.utc.iso8601,
      "ins" => @tx.ins.map(&:to_representation),
      "outs" => @tx.outs.map(&:to_representation)
    }
  end
end