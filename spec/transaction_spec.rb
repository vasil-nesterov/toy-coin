# typed: false

require 'rspec'

RSpec.describe Transaction do
  let(:key) { Key.load_from_file('spec/fixtures/alice_test.key') }
  let(:transaction) { 
    Transaction.new(
      sender: key.address,
      recipient: 'Bob', 
      value: 10.5
    )
  }

  describe '#id' do
    it 'is a hexdigest of the transaction' do
      expect(
        transaction.id
      ).to eq('b7f87efc8ce3af1e7f3f64ab86f80bd50c3edb07215c4c96326bf6039e28ab5c')
    end
  end

  it '#to_h' do
    expect(transaction.to_h.keys).to include(*%w[sender recipient value])
  end

  describe '#has_valid_signature?' do
    it 'returns true when signature is valid' do
      transaction.signature = key.sign(transaction.id)
      expect(transaction.has_valid_signature?).to be(true)
    end

    it 'returns false when signature is nil' do
      expect(transaction.has_valid_signature?).to be(false)
    end

    it 'returns false when signature is invalid' do
      transaction.signature = key
        .sign(transaction.id)
        .tap { _1[13] = '0' }

      expect(transaction.has_valid_signature?).to be(false)
    end
  end

  describe '#sign_with_key' do
    it 'sets the signature' do
      transaction.sign_with_key(key)
      expect(transaction.signature).to be_a(String)
    end
  end

  describe Transaction::Contract do
    subject(:contract) { Transaction::Contract.new }

    it 'validates transactions' do
      expect(contract.call(sender: 'Alice', recipient: 'Bob', value: 10.5).errors).to be_empty
      expect(contract.call(sender: '', recipient: '', value: 0).errors.count).to eq(3)
    end
  end
end