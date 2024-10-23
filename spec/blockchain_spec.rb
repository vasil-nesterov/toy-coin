# typed: strict

RSpec.describe Blockchain do
  T.bind(self, T.untyped)
  
  let(:blockchain) { 
    BlockchainStorage
      .new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json")
      .read
      .first
  }

  describe "#current_complexity" do
    it "returns the complexity of the first block" do
      expect(blockchain.current_complexity).to eq(1)
    end
  end
  
  describe "#height" do
    it "returns the number of blocks in the chain" do
      expect(blockchain.height).to eq(1)
    end
  end

  describe "#to_representation" do
    it "returns serialized blockchain" do
      expect(blockchain.to_representation).to eq([
        {
          "dgst" => "0b9f6c343f69404bd1159a0d9b5e8cac2cd685f3678240a2cd7605e49553b2dc",
          "ver" => 2,
          "prev_dgst" => "",
          "nonce" => 20,
          "chain_tweaks" => {
            "complexity" => 1
          },
          "txs" => [
            {
              "dgst" => "934bf3e59fd671b799c92f95853aaf7c48d016093d89b503c9e6f12bef7c30e3",
              "at" => "2024-10-22T18:30:36Z",
              "ins" => [
      
              ],
              "outs" => [
                {
                  "dest_pub" => "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c",
                  "millis" => 1000
                }
              ],
              "wits" => [
      
              ]
            }
          ]
        }
      ])
    end
  end

  describe "#add_block" do
    let(:block) { 
      Block.new(
        ver: Block::CURRENT_VERSION,
        prev_dgst: blockchain.last_block_dgst,
        nonce: 21,
        txs: []
      )
    }

    it "adds the new block to the chain" do
      blockchain # We need Blockchain to be initialized before mocking

      expect_any_instance_of(
        BlockRuleSet
      ).to receive(:satisfied?).and_return(true)

      expect {
        blockchain.add_block(block)
      }.to change { blockchain.height }.by(1)
    end

    it "throws error if the new block doesn't satisfy rules" do
      expect {
        blockchain.add_block(block)
      }.not_to change { blockchain.height }
    end
  end
end