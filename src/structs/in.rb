# typed: strict

require 'sorbet-runtime'

class In < T::Struct
  extend T::Sig
  prop :tx_id, String
  prop :out_i, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(In) }
  def self.from_hash(payload)
    new(
      tx_id: payload['tx_id'], 
      out_i: payload['out_i']
    )
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_hash
    {
      tx_id: tx_id,
      out_i: out_i
    }
  end
end