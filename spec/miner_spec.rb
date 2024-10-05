# typed: false
RSpec.describe Miner do
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }
  let(:node) { Node.new(blockchain_storage: blockchain_storage) }

  let(:miner) { 
    Miner.new(
      node: node,
      private_key: Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key")
    ) 
  }

  describe '#mine_next_block' do
    it 'adds a new block to the blockchain' do
      expect { 
        miner.mine_next_block
      }.to change { node.to_h[:blockchain][:blocks].length }.by(1)
    end
  end
end
