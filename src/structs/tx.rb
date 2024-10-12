# typed: strict

require 'sorbet-runtime'
require 'time'

class Tx < T::Struct
  extend T::Sig

  prop :dgst, String
  prop :at, Time

  prop :ins, T::Array[In]
  prop :outs, T::Array[Out]

  prop :wits, T::Array[[String, String]] # Pub key, signature. TODO: Rework into a better struct

  sig { params(payload: T::Hash[String, T.untyped]).returns(Tx) }
  def self.from_hash(payload)
    new(
      dgst: payload['dgst'],
      at: Time.parse(payload['at']),
      ins: payload['ins'].map { |input| In.from_hash(input) },
      outs: payload['outs'].map { |output| Out.from_hash(output) },
      wits: payload['wits']
    )
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def to_hash
    {
      dgst: dgst,
      at: at.iso8601,
      ins: ins.map(&:to_hash),
      outs: outs.map(&:to_hash),
      wits: wits
    }
  end
  
  sig { returns(T::Boolean) }
  def coinbase?
    ins.empty?
  end
end
