# typed: false
require 'rspec'

RSpec.describe Mempool do
  let(:transaction) { 
    Transaction.new(
      sender: 'Alice', 
      recipient: 'Bob', 
      value: 10.0 
    )
  }
  let(:mempool) { Mempool.new }

  describe '#add_transaction' do
    it 'adds a transaction to the mempool' do
      mempool.add_transaction(transaction)

      expect(mempool.to_h).to include(transaction.to_h)
    end
  end

  context 'with transaction' do
    before do
      mempool.add_transaction(transaction)
    end

    describe '#wipe' do
      it 'returns the transactions and clears the mempool' do
        result = mempool.wipe
    
        expect(result).to be_an(Array)
        expect(result.count).to eq(1)
        expect(result).to all(be_a(Transaction))

        expect(mempool.to_h).to be_empty
      end
    end

    describe '#to_h' do
      it 'returns an array of transaction hashes' do
        expect(mempool.to_h).to include(transaction.to_h)
      end
    end
  end
end