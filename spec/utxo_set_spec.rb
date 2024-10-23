# typed: strict

RSpec.describe UTXOSet do
  T.bind(self, T.untyped)

  extend T::Sig

  sig { params(id: String, ins: T::Array[In], outs: T::Array[Out]).returns(Tx) }
  def new_tx(id:, ins: [], outs: [])
    Tx.new(
      dgst: id,
      at: Time.now,
      ins: ins,
      outs: outs,
      wits: []
    )
  end

  let(:alice_address) { 
    KeyStorage.new("spec/fixtures/alice_test.key").read[:public_key].hex 
  }
  let(:bob_address) { 
    KeyStorage.new("spec/fixtures/bob_test.key").read[:public_key].hex 
  }

  let(:empty_utxo_set) { UTXOSet.new }
  let(:utxo_set) { 
    UTXOSet.new.tap { |utxo_set|
      utxo_set.process_transaction(
        new_tx(
          id: "tx1",
          outs: [
            Out.new(dest_pub: alice_address, millis: 100),
            Out.new(dest_pub: bob_address, millis: 200)
          ]
        )
      )
      utxo_set.process_transaction(
        new_tx(
          id: "tx2",
          ins: [In.new(tx_id: "tx1", out_i: 0)],
          outs: [
            Out.new(dest_pub: alice_address, millis: 30),
            Out.new(dest_pub: bob_address, millis: 70)
          ]
        )
      )
    }
  }

  describe "#to_representation" do
    it "returns the utxos in the set" do
      expect(utxo_set.to_representation).to eq([
        {"tx_id" => "tx1", "out_i" => 1, "dest_pub" => bob_address, "millis" => 200},
        {"tx_id" => "tx2", "out_i" => 0, "dest_pub" => alice_address, "millis" => 30},
        {"tx_id" => "tx2", "out_i" => 1, "dest_pub" => bob_address, "millis" => 70}
      ])
    end
  end

  describe "#balance_for" do
    it "starts with 0" do
      expect(
        empty_utxo_set.balance_for(alice_address)
      ).to eq(0)
    end

    it "computes balance after a series of txs" do
      expect(
        utxo_set.balance_for(alice_address)
      ).to eq(30)

      expect(
        utxo_set.balance_for(bob_address)
      ).to eq(270)
    end
  end
end
