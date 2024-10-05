# typed: false
RSpec.describe Miner do
  let(:alice) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }

  let(:node) { Node.new(node_name: 'alice', private_key: alice, blockchain_storage: blockchain_storage) }

  let(:miner) { 
    Miner.new(
      blockchain: node.instance_variable_get(:@blockchain), 
      mempool: Mempool.new,
      private_key: Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key"),
      node: node
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
