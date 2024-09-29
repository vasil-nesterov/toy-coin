RSpec.describe BlockchainStorage do
  let(:blockchain) { 
    Blockchain.new(
      [
        Block.new(
          index: 1,
          timestamp: Time.parse("2024-09-29T11:30:31Z"),
          proof: 1,
          transactions: [
            Transaction.new(sender: "alice", recipient: "bob", value: 1.0)
          ],
          digest: "a03a71030b23fa5cf246c00488459b7a085624840c271910254a7c1e89b47483",
          previous_block_digest: "980a56338b6ccc253a50aa47714aeee9bd75d4beef764b329433dfeb0ea177bc"
        ),
        Block.new(
          index: 0,
          timestamp: Time.parse("2024-09-29T11:29:34Z"),
          proof: 0,
          transactions: [],
          digest: "980a56338b6ccc253a50aa47714aeee9bd75d4beef764b329433dfeb0ea177bc",
          previous_block_digest: ""
        )
      ]
    )
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