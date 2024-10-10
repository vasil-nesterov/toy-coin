# typed: false

RSpec.describe Output do
  let(:payload) { {
    'destination_pub' => 'abc123',
    'amount' => 100
  } }

  describe '.from_hash' do
    it 'creates an Output instance from a hash' do
      output = Output.from_hash(payload)

      expect(output).to be_a(Output)
      expect(output.destination_pub).to eq('abc123')
      expect(output.amount).to eq(100)
    end
  end
end
