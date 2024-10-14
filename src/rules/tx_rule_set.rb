# typed: strict

class TxRuleSet
  extend T::Sig

  sig { returns(T::Array[String]) }
  attr_reader :errors

  sig { params(tx: Tx, utxo_set: UTXOSet).void }
  def initialize(tx:, utxo_set:)
    @tx = tx
    @utxo_set = utxo_set

    @errors = T.let([], T::Array[String])
  end

  # TODO: 
  #   - Inputs are valid
  #   - Outputs are valid
  #   - Outputs < Inputs OR coinbase
  #   - ...
  sig { returns(T::Boolean) }
  def satisfied?
    @errors = []

    dgst_is_valid
    ins_have_correct_wits

    @errors.empty?
  end

  private

  sig { void }
  def dgst_is_valid
    unless TxDigest.new(@tx).hex == @tx.dgst
      @errors << "Tx digest is invalid: `#{@tx}`"
    end
  end

  # TODO: test it out
  sig { returns(T::Boolean) }
  def ins_have_correct_wits
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
