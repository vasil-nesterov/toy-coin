# typed: strict

RSpec.describe TxRuleSet do
  T.bind(self, T.untyped)

  let(:tx) { 
    Tx.new(
      dgst: "0",
      at: Time.parse("2024-01-01T00:00:00Z"),
      ins: [],
      outs: [],
      wits: [],
    )
  }
  subject(:rule_set) { TxRuleSet.new(tx:, utxo_set: UTXOSet.new) }

  describe "#dgst_is_valid" do
    it "is satisfied when dgst is valid" do
      tx.dgst = TxDigest.new(tx).hex

      expect(rule_set.satisfied?).to be(true)
      expect(rule_set.errors).to be_empty
    end

    it "isn't satisfied when dgst is invalid" do
      tx.dgst = TxDigest.new(tx).hex
      tx.dgst[5] = "5"

      expect(rule_set.satisfied?).to be(false)
      expect(rule_set.errors).not_to be_empty
    end
  end
end
