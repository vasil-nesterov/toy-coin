# typed: false

RSpec.describe Wallet do
  let(:alice) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }
  let(:node) { Node.new(blockchain_storage: blockchain_storage) }
  let(:wallet) { Wallet.new(node: node, key: alice) }

  describe '#to' do
    it 'tells how many coins are in the wallet' do
      expect(wallet.to_h[:balance]).to eq(0.5)
    end
  end

  describe '#send_coins' do
    it 'creates a transaction and adds it to the mempool' do
      expect {
        wallet.send_coins('bob', 0.5)
      }.to change { node.to_h[:mempool].size }.by(1)

      expect(wallet.to_h[:balance]).to eq(0.0)
    end
  end

  context 'with tx' do
    let(:transaction) { 
      Transaction.new(sender: alice.address, recipient: 'bob', value: 0.5)
        .tap { _1.sign_with_key(alice) }
    }

    describe '#mine_next_block' do
      it 'mines a new block and adds it to the blockchain, including transactions from the mempool' do
        node.add_transaction_to_mempool(transaction)

        expect {
          wallet.mine_next_block.join
        }.to change { node.to_h.dig(:blockchain, :blocks).length }.by(1)

        expect(node.to_h[:mempool]).to be_empty
      end
    end
  end
end
