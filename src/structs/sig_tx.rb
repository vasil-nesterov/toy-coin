# typed: strict

require 'sorbet-runtime'

class SigTx < T::Struct
  extend T::Sig

  prop :tx, Tx
  prop :in_sigs, T::Array[String]

  sig { params(payload: T::Hash[String, T.untyped]).returns(SigTx) }
  def self.from_hash(payload)
      tx = Tx.from_hash(payload['tx'])
    
    new(tx:, in_sigs: payload['in_sigs'])
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_hash
    {
      tx: tx.to_hash,
      in_sigs: in_sigs
    }
  end
end
