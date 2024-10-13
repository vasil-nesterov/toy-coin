# typed: strict

class UTXO < T::Struct
  extend T::Sig
  
  const :tx_id, String
  const :out_i, Integer
  
  const :dest_pub, String
  const :millis, Integer

  sig { returns(T::Hash[String, T.untyped]) }
  def to_representation
    {
      "tx_id" => tx_id,
      "out_i" => out_i,
      "dest_pub" => dest_pub,
      "millis" => millis
    }
  end
end
