# typed: false

RSpec.describe Input do
  let(:payload) { { 'tx_id' => 'abc123', 'output_index' => 0 } }

  describe '.from_hash' do
    it 'creates an Input from a hash' do
      input = Input.from_hash(payload)

      expect(input).to be_a(Input)
      expect(input.tx_id).to eq('abc123')
      expect(input.output_index).to eq(0)
    end
  end
end
