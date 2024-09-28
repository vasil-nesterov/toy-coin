require 'rspec'

RSpec.describe Mempool do
  let(:tx_attrs) { { sender: 'Alice', recipient: 'Bob', value: 10.0 } }
  let(:mempool) { 
    m = Mempool.new 
    m.add_transaction(Transaction.new(**tx_attrs))
    m
  }

  describe '#add_transaction' do
    it 'adds a transaction to the mempool' do
      mempool.add_transaction(Transaction.new(**tx_attrs))
      expect(mempool.to_h).to include(tx_attrs)
    end
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
      expect(mempool.to_h).to eq([tx_attrs])
    end
  end
end