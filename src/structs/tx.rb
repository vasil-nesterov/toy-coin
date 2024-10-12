# typed: strict

require 'sorbet-runtime'
require 'time'

class Tx < T::Struct
  extend T::Sig

  prop :dgst, String
  prop :at, Time

  prop :ins, T::Array[In]
  prop :outs, T::Array[Out]

  prop :in_sigs, T::Array[String]

  sig { params(payload: T::Hash[String, T.untyped]).returns(Tx) }
  def self.from_hash(payload)
    new(
      dgst: payload['dgst'],
      at: Time.parse(payload['at']),
      ins: payload['ins'].map { |input| In.from_hash(input) },
      outs: payload['outs'].map { |output| Out.from_hash(output) },
      in_sigs: payload['in_sigs']
    )
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_hash
    {
      dgst: dgst,
      at: at.iso8601,
      ins: ins.map(&:to_hash),
      outs: outs.map(&:to_hash),
      in_sigs: in_sigs
    }
  end
  
  sig { returns(T::Boolean) }
  def coinbase?
    ins.empty?
  end
end
