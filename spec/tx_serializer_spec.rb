# typed: strict

RSpec.describe TxSerializer do
  T.bind(self, T.untyped)

  let(:payload) {
    {
      "dgst" => "123",
      "at" => "2024-01-01T00:00:00Z",
      "ins" => [
        { "tx_id" => "txid1", "out_i" => 0 }
      ],
      "outs" => [
        { "dest_pub" => "pub1", "millis" => 100 }
      ],
      "wits" => [
        { "pub" => "pub1", "sgn" => "sgn1" }
      ]
    }
  }
  let(:tx) { TxSerializer.from_representation(payload) }

  describe "#from_representation" do
    it "returns a Tx instance" do
      expect(tx).to be_a(Tx)
    end
  end

  describe "#full_representation" do
    it "returns the full representation of the transaction" do
      expect(
        TxSerializer.new(tx).full_representation
        ).to eq(payload)
    end
  end

  describe "#representation_for_digest" do
    it "returns representation with only the fields needed for the digest" do
      expect(
        TxSerializer.new(tx).representation_for_digest
      ).to eq({
        "at" => "2024-01-01T00:00:00Z",
        "ins" => [
          { "tx_id" => "txid1", "out_i" => 0 }
        ],
        "outs" => [
          { "dest_pub" => "pub1", "millis" => 100 }
        ]
      })
    end
  end
end
