# typed: strict

RSpec.describe Tx do
  T.bind(self, T.untyped)

  let(:tx) { 
    Tx.new(
      dgst: 'abc123',
      at: Time.now,
      ins: [],
      outs: [],
      wits: []
    )
  }
  
  describe '#coinbase?' do
    it 'returns true if the transaction is a coinbase' do
      expect(tx.coinbase?).to be(true)
    end

    it 'returns false if the transaction is not coinbase' do
      tx.ins = [In.new(tx_id: 'abc123', out_i: 0)]

      expect(tx.coinbase?).to be(false)
    end
  end
end
