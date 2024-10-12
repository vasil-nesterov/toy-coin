# typed: false

RSpec.describe Out do
  let(:payload) { {
    'dest_pub' => 'abc123',
    'millis' => 1_000
  } }

  describe '.from_hash' do
    it 'creates an Out instance from a hash' do
      output = Out.from_hash(payload)

      expect(output).to be_a(Out)
      expect(output.dest_pub).to eq('abc123')
      expect(output.millis).to eq(1_000)
    end
  end
end
