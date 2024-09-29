require 'rspec'
require_relative '../src/blockchain'

RSpec.describe Blockchain do
  let(:blockchain) { 
    bc = Blockchain.new(ENV.fetch('COMPLEXITY').to_i)
    bc.add_block(Block.new_genesis)
    bc
  }
  
  describe '#to_h' do
    it 'returns complexity + blocks' do
      expect(blockchain.to_h[:complexity]).to eq(1)
      expect(blockchain.to_h[:blocks]).to be_a(Array)
    end
  end

  describe '#add_block' do
    let(:valid_attrs) {
      {
        index: 1, 
        timestamp: Time.now,
        proof: ProofOfWork.new(ENV.fetch('COMPLEXITY').to_i).next_proof(blockchain.last_block.proof),
        transactions: [],
        previous_block_digest: blockchain.last_block.digest
      }
    }

    it 'adds the new block to the chain' do
      expect {
        blockchain.add_block(Block.new(valid_attrs))
      }.to change { blockchain.length }.by(1)
    end

    it "throws error if the new block doesn't reference the last block in chain" do
      expect {
        blockchain.add_block(
          Block.new(valid_attrs.merge(previous_block_digest: 'invalid_digest')
          )
        )
      }.to raise_error(Blockchain::InvalidBlockAddedError)
    end

    it 'throws error if the new block has invalid proof' do
      expect {
        blockchain.add_block(
          Block.new(valid_attrs.merge(proof: 123))
        )
      }.to raise_error(Blockchain::InvalidBlockAddedError)
    end
  end
end