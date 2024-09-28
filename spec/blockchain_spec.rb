require 'rspec'
require_relative '../src/blockchain'

RSpec.describe Blockchain do
  let(:blockchain) { Blockchain.new }

  describe '#initialize' do
    it 'creates a blockchain with a genesis block' do
      expect(blockchain.blocks.length).to eq(1)
      expect(blockchain.last_block.index).to eq(0)
    end
  end

  describe '#to_h' do
    it 'returns an array of block hashes' do
      expect(blockchain.to_h).to be_an(Array)
      expect(blockchain.to_h.first).to be_a(Hash)
    end
  end
end