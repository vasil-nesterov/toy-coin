# typed: false

RSpec.describe Tx do
  describe '.from_hash' do
    let(:payload) do
      {
        'id' => 'abc123',
        'at' => '2024-01-01T00:00:00Z',
        'in' => [
          { 'tx_id' => 'abc123', 'out_i' => 0 }
        ],
        'out' => [
          { 'dest_pub' => 'def456', 'millis' => 1_000 }
        ]
      }
    end

    it 'creates a Tx instance from a hash' do
      tx = Tx.from_hash(payload)

      expect(tx).to be_a(Tx)
      expect(tx.in).to be_an(Array)
      expect(tx.in.first).to be_an(In)
      expect(tx.out).to be_an(Array)
      expect(tx.out.first).to be_an(Out)
    end
  end
end
