# typed: false
RSpec.describe Miner do
  let(:blockchain) { 
    Blockchain
      .new(ENV.fetch('COMPLEXITY').to_i)
      .tap { _1.add_block(Block.new_genesis) }
  }
  let(:miner) { 
    Miner.new(
      blockchain: blockchain, 
      mempool: Mempool.new,
      private_key: Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key")
    ) 
  }

  describe '#mine_next_block' do
    it 'adds a new block to the blockchain' do
      expect { 
        miner.mine_next_block
      }.to change { blockchain.length }.by(1)
    end
  end
end
