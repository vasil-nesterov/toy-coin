# typed: false

RSpec.describe TransactionValidator do
  let(:coinbase_tx) { 
    Transaction.from_hash(
      {
        "sender" => "0",
        "recipient" => "ce452613733d00ef8486c475c85f0d8709053802b02e04b8d03a1fbe98506f24",
        "value" => 1.0
      }
    )
  }

  let(:transaction) {
    Transaction.from_hash(
      {
        "sender" => "ce452613733d00ef8486c475c85f0d8709053802b02e04b8d03a1fbe98506f24",
        "recipient" => "f88ccd9d47b17f8d44429fddd7e01a0876240151568cda9b1c91b4832cb15bc6",
        "value" => 0.5,
        "signature" => "bc9a57771fd81496444236212f51a68d690268cd6403f8531b78882f2dff0c317a7f79c6abc9c0a5b19caa54a0aff2469974501e26c397cc0da83935fcd82c03"
      }
    )
  }

  describe '#call' do
    it 'returns true when coinbase transaction is valid' do
      expect(TransactionValidator.new(coinbase_tx).call).to be(true)
    end

    it 'returns true when transaction is valid' do
      expect(TransactionValidator.new(transaction).call).to be(true)
    end

    it 'returns false when transaction is invalid' do
      transaction.signature[0] = '0'
      expect(TransactionValidator.new(transaction).call).to be(false)
    end
  end
end

# describe '#has_valid_signature?' do
# it 'returns true when signature is valid' do
#   transaction.signature = key.sign(transaction.id)
#   expect(transaction.has_valid_signature?).to be(true)
# end

# it 'returns false when signature is nil' do
#   expect(transaction.has_valid_signature?).to be(false)
# end

# it 'returns false when signature is invalid' do
#   transaction.signature = key
#     .sign(transaction.id)
#     .tap { _1[13] = '0' }

#   expect(transaction.has_valid_signature?).to be(false)
# end
# end