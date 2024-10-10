# typed: false

RSpec.describe Input do
  let(:payload) { { 'txid' => 'abc123', 'out_i' => 0 } }

  describe '.from_hash' do
    it 'creates an Input from a hash' do
      input = Input.from_hash(payload)

      expect(input).to be_a(Input)
      expect(input.txid).to eq('abc123')
      expect(input.out_i).to eq(0)
    end
  end
end
