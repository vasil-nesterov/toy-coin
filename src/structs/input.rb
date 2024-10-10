# typed: strict

require 'sorbet-runtime'

class Input < T::Struct
  extend T::Sig
  prop :tx_id, String
  prop :output_index, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(Input) }
  def self.from_hash(payload)
    new(
      tx_id: payload['tx_id'], 
      output_index: payload['output_index']
    )
  end
end
