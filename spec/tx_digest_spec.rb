# typed: strict

RSpec.describe TxDigest do
  T.bind(self, T.untyped)

  let(:tx) { 
    Tx.new(
      dgst: "",
      at: Time.parse("2024-01-01T00:00:00Z"),
      ins: [
        In.new(
          tx_id: "tx_id1",
          out_i: 0
        )
      ],
      outs: [
        Out.new(
          millis: 100,
          dest_pub: "dest_pub1"          
        )
      ],
      wits: [
        Wit.new(
          pub: "pub1",
          sgn: "sgn1"
        )
      ]
    )
  }

  describe "#hex" do
    it "returns the hex digest of the tx" do
      expect(
        TxDigest.new(tx).hex
      ).to eq("508adb7a68478ef9f900d6f10d8247110af0ace1b124f3e27577f9c0e3efef95")
    end
  end

  describe "#payload" do
    it "returns the payload of the digest" do
      expect(TxDigest.new(tx).payload).to eq('
        {
          "at":"2024-01-01T00:00:00Z",
          "ins":[
            {
              "tx_id":"tx_id1",
              "out_i":0
            }
          ],
          "outs":[
            {
              "dest_pub":"dest_pub1",
              "millis":100
            }
          ]
        }
      '.tr("\n ", ''))
    end
  end
end
