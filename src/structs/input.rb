# typed: strict

require 'sorbet-runtime'

class Input < T::Struct
  extend T::Sig
  prop :txid, String
  prop :out_i, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(Input) }
  def self.from_hash(payload)
    new(
      txid: payload['txid'], 
      out_i: payload['out_i']
    )
  end
end
