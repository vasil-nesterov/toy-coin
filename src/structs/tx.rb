# typed: strict

class Tx < T::Struct
  extend T::Sig

  # TODO: rename to id
  prop :dgst, String
  prop :at, Time

  prop :ins, T::Array[In]
  prop :outs, T::Array[Out]

  prop :wits, T::Array[Wit]
  
  sig { returns(T::Boolean) }
  def coinbase?
    ins.empty?
  end
end
