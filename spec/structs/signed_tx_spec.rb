# typed: false

RSpec.describe SignedTx do
  describe '.from_hash' do
    it 'creates a SignedTx instance from a hash' do
      payload = {
        'tx' => {
          'id' => 'abc123',
          'at' => '2024-01-01T00:00:00Z',
          'in' => [{ 'tx_id' => 'abc123', 'out_i' => 0 }],
          'out' => [{ 'dest_pub' => 'def456', 'millis' => 1_000 }]
        },
        'in_sigs' => ['signature1']
      }

      signed_tx = SignedTx.from_hash(payload)

      expect(signed_tx).to be_a(SignedTx)
      expect(signed_tx.tx).to be_a(Tx)
      expect(signed_tx.in_sigs).to eq(['signature1'])
    end
  end
end