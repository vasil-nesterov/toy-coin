RSpec.describe Node do
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }
  let(:node) { Node.new(blockchain_storage) }

  describe '#initialize' do
    it 'initialized Node with Blockchain loaded from BlockchainStorage' do
      expect(node).to be_a(Node)
      
      expect(node.to_h.dig(:blockchain, :blocks)).to be_a(Array)

      expect(node.to_h[:mempool]).to be_a(Array)
      expect(node.to_h[:mempool]).to be_empty
    end
  end

  context 'with tx' do
    let(:transaction) { Transaction.new(sender: 'alice', recipient: 'bob', value: 1.0) }

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
          node.mine_next_block
        }.to change { node.to_h.dig(:blockchain, :blocks).length }.by(1)

        expect(node.to_h[:mempool]).to be_empty
      end
    end
  end
end
