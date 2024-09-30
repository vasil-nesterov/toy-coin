# typed: false
RSpec.describe BlockchainStorage do
  let(:blockchain) { 
    bc = Blockchain.new(ENV.fetch('COMPLEXITY').to_i)

    bc.add_block(
      Block.new(
        index: 0,
        timestamp: Time.parse("2024-09-29T11:29:34Z"),
        proof: 0,
        transactions: [],
        previous_block_digest: ""
      )
    )

    bc.add_block(
      Block.new(
        index: 1,
        timestamp: Time.parse("2024-09-29T11:30:31Z"),
        proof: 60645174128734550026333393225151468053124826214274642281417246618300967955651,
        transactions: [
          Transaction.new(sender: "alice", recipient: "bob", value: 1.0)
        ],
        previous_block_digest: "980a56338b6ccc253a50aa47714aeee9bd75d4beef764b329433dfeb0ea177bc"
      )
    )
    
    bc
  }

  let(:path_to_blockchain_file) { "#{ROOT_DIR}/spec/tmp/blockchain.json" }
  let(:storage) { BlockchainStorage.new(path_to_blockchain_file) }

  describe "#load" do
    it "loads the blockchain from a file" do
      storage.save(blockchain)

      loaded_blockchain = storage.load
      expect(loaded_blockchain).to eq(blockchain)
    end
  end

  describe "#save" do
    it "saves the blockchain to a file" do
      storage.save(blockchain)
      expect(File.exist?(path_to_blockchain_file)).to be_truthy
    end
  end
end