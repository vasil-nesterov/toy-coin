# typed: strict

require 'sorbet-runtime'

class Output < T::Struct
  extend T::Sig
  
  prop :dest_pub, String
  prop :amount, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(Output) }
  def self.from_hash(payload)
    new(
      dest_pub: payload['dest_pub'],
      amount: payload['amount']
    )
  end
end
