# typed: strict

RSpec.describe BlockchainStorage do
  T.bind(self, T.untyped)

  let(:path_to_file) { "#{ROOT_DIR}/spec/fixtures/simple_blockchain.json" }
  let(:storage) { BlockchainStorage.new(path_to_file) }

  describe "#load" do
    it "loads the blockchain from a file, and computes UTXO set" do
      blockchain, utxo_set = storage.read

      expect(blockchain.height).to eq(1)

      expect(utxo_set.serialize).to eq([
        {
          "tx_id" => "d00b4dac7beef42023239c25189f18e457d804438c2b5e8d41ee05f9b3245828",
          "out_i" => 0,
          "dest_pub" => "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c",
          "millis" => 1000
        }
      ])
    end
  end
end
