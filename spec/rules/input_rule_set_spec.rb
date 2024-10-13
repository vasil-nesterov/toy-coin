# typed: false

RSpec.describe InputRuleSet do
  let(:input) { JSON.parse(File.read('spec/fixtures/blockchain_2.json'))['txs'][0]['inputs'][0] }
  subject(:rule_set) { described_class.new(input) }

  describe '#satisfied?' do
    it 'returns true when all conditions are met' do
      expect(rule_set).to be_satisfied
    end

    it 'returns false when tx_id is incorrect' do
      allow(input).to receive(:tx_id).and_return('short')
      expect(rule_set).not_to be_satisfied
    end

    it 'returns false when out_i is negative' do
      allow(input).to receive(:out_i).and_return(-1)
      expect(rule_set).not_to be_satisfied
    end
  end
end
