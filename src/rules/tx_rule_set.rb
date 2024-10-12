# typed: strict

class TxRuleSet
  extend T::Sig

  sig { params(tx: Tx).void }
  def initialize(tx)
    @tx = tx
  end

  sig { returns(T::Boolean) }
  def satisfied?
    in_sigs_are_valid?  
    # TODO: 
    #   - Inputs are valid
    #   - Outputs are valid
    #   - Outputs < Inputs OR coinbase
    #   - ...
  end

  private

  # TODO: test it out
  sig { returns(T::Boolean) }
  def in_sigs_are_valid?
    @tx.ins.map.with_index do |input, index|
      pub_key_hex, signature = @tx.wits[index]
      if pub_key_hex.nil? || signature.nil?
        next false
      else
        PublicKey
          .new(pub_key_hex)
          .verify(signature, @tx.to_hash.to_json)
      end
    end.all?
  end
end
