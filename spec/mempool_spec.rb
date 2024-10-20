# typed: strict

RSpec.describe Mempool do
  T.bind(self, T.untyped)

  let(:mempool) { Mempool.new }

  describe "#add_tx" do
    it "adds a transaction to the mempool" do
      expect {
        mempool.add_tx(simple_coinbase_tx)
      }.to change { mempool.to_representation.count }.by(1)
    end
  end

  describe "#to_representation" do
    let(:representation) { mempool.to_representation }

    it "returns an array of serialized txs" do
      expect(representation).to eq([])
    end
  end
end