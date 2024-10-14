# typed: strict

RSpec.describe UTXO do
  T.bind(self, T.untyped)

  let(:utxo) {
    UTXO.new(
      tx_id: "abc123",
      out_i: 0,
      dest_pub: "public_key",
      millis: 1000
    )
  }

  describe "#to_representation" do
    it "returns a hash representation of the UTXO" do
      expect(utxo.to_representation).to eq({
        "tx_id" => "abc123",
        "out_i" => 0,
        "dest_pub" => "public_key",
        "millis" => 1000
      })
    end
  end
end
