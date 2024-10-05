
require 'rspec'
require_relative '../src/wallet'
require_relative '../src/node'
require_relative '../src/key'

RSpec.describe Wallet do
  let(:alice) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }
  let(:blockchain_storage) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }
  let(:node) { Node.new(node_name: 'alice', private_key: alice, blockchain_storage: blockchain_storage) }
  let(:wallet) { Wallet.new(node: node, key: alice) }

  describe '#balance' do
    it 'tells how many coins are in the wallet' do
      expect(wallet.balance).to eq(0.5)
    end
  end

  describe '#send_coins' do
    it 'creates a transaction and adds it to the mempool' do
      expect {
        wallet.send_coins('bob', 0.5)
      }.to change { node.to_h[:mempool].size }.by(1)

      expect(wallet.balance).to eq(0.0)
    end
  end
end
