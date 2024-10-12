# typed: strict

require 'sorbet-runtime'

class Out < T::Struct
  extend T::Sig
  
  prop :dest_pub, String
  prop :millis, Integer

  sig { params(payload: T::Hash[String, T.untyped]).returns(Out) }
  def self.from_hash(payload)
    new(
      dest_pub: payload['dest_pub'],
      millis: payload['millis']
    )
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_hash
    {
      dest_pub: dest_pub,
      millis: millis
    }
  end
end
