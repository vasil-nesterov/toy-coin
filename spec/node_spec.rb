# typed: false

RSpec.describe Node do
  let(:alice) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }

  let(:node) { Node.new(node_name: 'alice', private_key: alice, blockchain_storage: blockchain_storage) }

  describe '#initialize' do
    it 'initialized Node with Blockchain loaded from BlockchainStorage' do
      expect(node).to be_a(Node)
      expect(node.to_h[:node_name]).to eq('alice')
      expect(node.to_h[:address]).to eq(alice.address)

      expect(node.to_h.dig(:blockchain, :blocks)).to be_a(Array)

      expect(node.to_h[:mempool]).to be_a(Array)
      expect(node.to_h[:mempool]).to be_empty
    end
  end

  context 'with tx' do
    let(:transaction) { 
      Transaction.new(sender: alice.address, recipient: 'bob', value: 1.0)
        .tap { _1.sign_with_key(alice) }
    }

    describe '#add_transaction_to_mempool' do
      it 'adds a transaction to the mempool' do
        expect {
          node.add_transaction_to_mempool(transaction)  
        }.to change { node.to_h[:mempool].length }.by(1)
      end
    end

    describe '#mine_next_block' do
      it 'mines a new block and adds it to the blockchain, including transactions from the mempool' do
        node.add_transaction_to_mempool(transaction)

        expect {
          node.mine_next_block.join
        }.to change { node.to_h.dig(:blockchain, :blocks).length }.by(1)

        expect(node.to_h[:mempool]).to be_empty
      end
    end
  end
end
