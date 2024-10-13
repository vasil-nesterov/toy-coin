# typed: strict

class TxDigest
  extend T::Sig

  sig { params(tx: Tx).void }
  def initialize(tx)
    @tx = tx
  end

  sig { returns(String) }
  def hex
    Digest::Blake3.hexdigest(payload)
  end

  sig { returns(String) }
  def payload
    TxSerializer
      .new(@tx)
      .representation_for_digest
      .to_stable_json
  end
end