# typed: strict

RSpec.describe TxSerializer do
  T.bind(self, T.untyped)

  let(:tx) { 
    Tx.new(
      dgst: "123",
      at: Time.parse("2024-01-01T00:00:00Z"),
      ins: [
        In.new(
          tx_id: "txid1",
          out_i: 0
        )
      ],
      outs: [
        Out.new(
          dest_pub: "pub1",
          millis: 100
        )
      ],
      wits: []
    )
  }
  let(:serializer) { TxSerializer.new(tx) }

  describe "#representation_for_digest" do
    it "returns representation with only the fields needed for the digest" do
      serializer = TxSerializer.new(tx)
      expect(serializer.representation_for_digest).to eq({
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
