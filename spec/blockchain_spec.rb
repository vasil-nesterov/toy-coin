require 'rspec'
require_relative '../src/blockchain'

RSpec.describe Blockchain do
  let(:blockchain) { Blockchain.new }

  describe '#initialize' do
    it 'creates a blockchain with a genesis block' do
      expect(blockchain.as_json.length).to eq(1)
      expect(blockchain.as_json.first[:index]).to eq(0)
    end
  end

  describe '#as_json' do
    it 'returns an array of block hashes' do
      expect(blockchain.as_json).to be_an(Array)
      expect(blockchain.as_json.first).to be_a(Hash)
    end
  end
end
