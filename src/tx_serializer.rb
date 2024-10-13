# typed: strict

class TxSerializer
  extend T::Sig

  sig { params(payload: T::Hash[String, T.untyped]).returns(Tx) }
  def self.from_representation(payload)
    Tx.new(
      dgst: payload['dgst'],
      at: Time.parse(payload['at']),
      ins: payload['ins'].map { |input| In.from_representation(input) },
      outs: payload['outs'].map { |output| Out.from_representation(output) },
      wits: payload['wits'].map { |wit| Wit.from_representation(wit) }
    )
  end

  sig { params(tx: Tx).void }
  def initialize(tx)
    @tx = tx
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def full_representation
    { 
      "dgst" => @tx.dgst,
      "at" => @tx.at.utc.iso8601,
      "ins" => @tx.ins.map(&:to_representation),
      "outs" => @tx.outs.map(&:to_representation),
      "wits" => @tx.wits.map(&:to_representation)
    }
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def representation_for_digest
    full_representation.slice(
      "at", "ins", "outs"
    )
  end
end