# typed: strict

require 'sorbet-runtime'
require 'time'
class Tx < T::Struct
  extend T::Sig

  prop :id, String
  prop :at, Time

  prop :in, T::Array[Input]
  prop :out, T::Array[Output]

  sig { params(payload: T::Hash[String, T.untyped]).returns(Tx) }
  def self.from_hash(payload)
    new(
      id: payload['id'],
      at: Time.parse(payload['at']),
      in: payload['in'].map { |input| Input.from_hash(input) },
      out: payload['out'].map { |output| Output.from_hash(output) }
    )
  end
end