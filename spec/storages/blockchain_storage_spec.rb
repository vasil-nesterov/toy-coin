# typed: strict

RSpec.describe BlockchainStorage do
  T.bind(self, T.untyped)

  let(:path_to_file) { "#{ROOT_DIR}/spec/fixtures/simple_blockchain.json" }
  let(:storage) { BlockchainStorage.new(path_to_file) }

  describe "#load" do
    it "loads the blockchain from a file, and computes UTXO set" do
      blockchain, utxo_set = storage.read

      expect(blockchain.height).to eq(1)

      expect(utxo_set.to_representation).to eq([
        {
          "tx_id" => "934bf3e59fd671b799c92f95853aaf7c48d016093d89b503c9e6f12bef7c30e3",
          "out_i" => 0,
          "dest_pub" => "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c",
          "millis" => 1000
        }
      ])
    end
  end
end
