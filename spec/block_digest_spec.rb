# typed: strict

RSpec.describe BlockDigest do
  T.bind(self, T.untyped)

  let(:block) do
    Block.new(
      ver: 2,
      prev_dgst: "previous_digest",
      nonce: 12345,
      chain_tweaks: { complexity: 1 },
      txs: [
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
      ]
    )
  end

  describe "#hex" do
    it "returns hexadecimal digest of the block" do
      expect(
        BlockDigest.new(block).hex
      ).to eq("7f6a229f792c663793995a523ae147f3ad30cc63776526ff842094acc8bf2d27") 
    end
  end

  describe "#payload" do
    it "returns JSON string representation of the block for digest" do
      expect(
        BlockDigest.new(block).payload
      ).to eq('
        {
          "chain_tweaks":{"complexity":1},
          "nonce":12345,
          "prev_dgst":"previous_digest",
          "txs":[
            {
              "dgst":"",
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
              ],
              "wits":[
                {
                  "pub":"pub1",
                  "sgn":"sgn1"
                }
              ]
            }
          ],
          "ver":2
        }
      '.tr("\n ", ''))
    end
  end
end