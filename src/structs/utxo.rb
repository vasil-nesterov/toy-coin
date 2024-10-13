# typed: strict

class UTXO < T::Struct
  const :tx_id, String
  const :out_i, Integer
  
  const :dest_pub, String
  const :millis, Integer
end
