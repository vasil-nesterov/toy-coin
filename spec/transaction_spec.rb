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

  describe '.from_hash' do
    it 'returns a Transaction' do
      tx = Transaction.from_hash(transaction.to_h)

      expect(tx.sender).to eq(key.address)
      expect(tx.recipient).to eq('Bob')
      expect(tx.value).to eq(10.5)
    end
  end

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

  describe '#sign_with_key' do
    it 'sets the signature' do
      transaction.sign_with_key(key)
      expect(transaction.signature).to be_a(String)
    end
  end
end