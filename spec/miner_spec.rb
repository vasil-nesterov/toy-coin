RSpec.describe Miner do
  let(:blockchain) { 
    bc = Blockchain.new(ENV.fetch('COMPLEXITY').to_i)
    bc.add_block(Block.new_genesis)
    bc
  }
  let(:miner) { Miner.new(blockchain: blockchain) }

  describe '#mine_next_block' do
    it 'adds a new block to the blockchain' do
      expect { 
        miner.mine_next_block(mempool: Mempool.new) 
      }.to change { blockchain.length }.by(1)
    end
  end
end
