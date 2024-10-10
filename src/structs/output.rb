# typed: strict

require 'sorbet-runtime'

class Output < T::Struct
  extend T::Sig
  
  prop :destination_pub, String
  prop :amount, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(Output) }
  def self.from_hash(payload)
    new(
      destination_pub: payload['destination_pub'],
      amount: payload['amount']
    )
  end
end
