# typed: strict

class Wit < T::Struct
  extend T::Sig
  
  const :pub, String
  const :sgn, String

  sig { params(payload: T::Hash[String, T.untyped]).returns(Wit) }
  def self.from_representation(payload)
    new(
      pub: payload['pub'],
      sgn: payload['sgn']
    )
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_representation
    {
      "pub" => pub,
      "sgn" => sgn
    }
  end
end