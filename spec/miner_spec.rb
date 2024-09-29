require 'rspec'
require_relative '../src/miner'
require_relative '../src/blockchain'

RSpec.describe Miner do
  let(:blockchain) { Blockchain.new([Block.new_genesis]) }
  let(:miner) { Miner.new(blockchain: blockchain, complexity: 1) }

  describe '#mine_next_block' do
    it 'adds a new block to the blockchain' do
      expect { miner.mine_next_block(mempool: Mempool.new) }.to change { blockchain.length }.by(1)
    end
  end
end
