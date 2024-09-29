require 'rspec'
require_relative '../src/blockchain'

RSpec.describe Blockchain do
  let(:blockchain) { Blockchain.new([Block.new_genesis]) }
  
  describe '#to_h' do
    it 'returns an array of block hashes' do
      expect(blockchain.to_h).to be_an(Array)
      expect(blockchain.to_h.first).to be_a(Hash)
    end
  end
end
