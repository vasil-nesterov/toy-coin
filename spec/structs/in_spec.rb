# typed: false

RSpec.describe In do
  let(:payload) { { 'tx_id' => 'abc123', 'out_i' => 0 } }

  describe '.from_hash' do
    it 'creates In from a hash' do
      input = In.from_hash(payload)

      expect(input).to be_a(In)
      expect(input.tx_id).to eq('abc123')
      expect(input.out_i).to eq(0)
    end
  end
end
