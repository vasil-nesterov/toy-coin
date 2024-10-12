# typed: strict

require 'rspec'
require 'sorbet-runtime'

RSpec.describe Miner do
  T.bind(self, T.untyped) # https://stackoverflow.com/a/76301199

  let(:bs) { BlockchainStorage.new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") }
  let(:miner) { Miner.new(complexity: 1, last_block_dgst: bs.load.last_block_dgst) }

  describe '#next_block' do
    it 'returns a new block' do
      expect(
        miner.next_block[0]
      ).to be_a(Block)
      # TODO: Better spec
    end

    it 'returns a private key which owns the coinbase tx output' do
      expect(
        miner.next_block[1]
      ).to be_a(Key)
      # TODO: Better spec
    end
  end
end
