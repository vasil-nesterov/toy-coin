# typed: strict

class TransactionValidator
  extend T::Sig

  sig { params(tx: Transaction).void }
  def initialize(tx)
    @tx = tx
  end

  sig { returns(T::Boolean) }
  def call
    result = [value_gt_zero?]
    result << has_valid_signature? unless @tx.coinbase?

    result.all?
  end

  private

  sig { returns(T::Boolean) }
  def value_gt_zero?
    @tx.value > 0
  end

  sig { returns(T::Boolean) }
  def has_valid_signature?
    signature_bytes = @tx.signature&.to_bytes # https://sorbet.org/docs/flow-sensitive#limitations-of-flow-sensitivity
    return false unless signature_bytes

    public_key = @tx.sender

    public_key = Ed25519::VerifyKey.new(public_key.to_bytes)
    public_key.verify(signature_bytes, @tx.id)
  rescue Ed25519::VerifyError
    false
  end
end