# typed: strict

RSpec.describe Miner do
  T.bind(self, T.untyped)

  let(:blockchain) { simple_blockchain }
  let(:public_key) { 
    KeyStorage
      .new("#{ROOT_DIR}/spec/fixtures/alice_test.key")
      .read[:public_key]
  }
  let(:miner) { 
    Miner.new(
      complexity: blockchain.current_complexity, 
      last_block_dgst: blockchain.last_block_dgst,
      public_key:
    )
  }

  describe "#next_block" do
    let(:new_block) { miner.next_block }

    it "returns a new valid block" do
      expect(new_block).to be_a(Block)
      
      expect {
        blockchain.add_block(new_block)
      }.to change { blockchain.height }.by(1)
    end
  end
end
