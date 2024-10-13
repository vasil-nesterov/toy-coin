# typed: strict

RSpec.describe UTXOSet do
  T.bind(self, T.untyped)

  let(:alice_address) { PrivateKey.load_from_file("spec/fixtures/alice_test.key").public_key.hex }
  let(:bob_address) { PrivateKey.load_from_file("spec/fixtures/bob_test.key").public_key.hex }
  let(:utxo_set) { UTXOSet.new }

  describe "#balance_for" do
    it "starts with 0" do
      expect(
        utxo_set.balance_for(alice_address)
      ).to eq(0)
    end

    it "computes balance after a series of txs" do
      tx = Tx.new(
        dgst: "tx1",
        at: Time.now,
        ins: [],
        outs: [Out.new(dest_pub: alice_address, millis: 100), Out.new(dest_pub: bob_address, millis: 200)],
        wits: []
      )
      utxo_set.process_transaction(tx)

      tx2 = Tx.new(
        dgst: "tx2",
        at: Time.now,
        ins: [In.new(tx_id: "tx1", out_i: 0)],
        outs: [Out.new(dest_pub: alice_address, millis: 30), Out.new(dest_pub: bob_address, millis: 70)],
        wits: []
      )
      utxo_set.process_transaction(tx2)

      expect(
        utxo_set.balance_for(alice_address)
      ).to eq(30)

      expect(
        utxo_set.balance_for(bob_address)
      ).to eq(270)
    end
  end
end
