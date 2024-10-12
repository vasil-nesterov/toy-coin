# typed: false

RSpec.describe BlockchainStorage do
  let(:path_to_file) { "#{ROOT_DIR}/spec/fixtures/simple_blockchain.json" }
  let(:storage) { BlockchainStorage.new(path_to_file) }

  describe "#load" do
    it "loads the blockchain from a file" do
      blockchain = storage.load
      expect(blockchain.height).to eq(2)
    end
  end
end
