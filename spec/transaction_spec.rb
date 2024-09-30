# typed: false
require 'rspec'
require_relative '../src/transaction'

RSpec.describe Transaction do
  let(:valid_transaction) { Transaction.new(sender: 'Alice', recipient: 'Bob', value: 10.5) }

  it '#to_h' do
    expect(valid_transaction.to_h).to eq(
      'sender' => 'Alice',
      'recipient' => 'Bob',
      'value' => 10.5
    )
  end

  describe Transaction::Contract do
    subject(:contract) { Transaction::Contract.new }

    it 'validates transactions' do
      expect(contract.call(sender: 'Alice', recipient: 'Bob', value: 10.5).errors).to be_empty
      expect(contract.call(sender: '', recipient: '', value: 0).errors.count).to eq(3)
    end
  end
end