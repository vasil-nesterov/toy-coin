# typed: strict

RSpec.describe Out do
  T.bind(self, T.untyped)
  
  let(:payload) { 
    {
      "dest_pub" => "abc123",
      "millis" => 1_000
    }
  }

  describe ".from_representation" do
    it 'creates an Out instance from a hash' do
      output = Out.from_hash(payload)

      expect(output).to be_a(Out)
      expect(output.dest_pub).to eq("abc123")
      expect(output.millis).to eq(1_000)
    end
  end

  describe "#to_representation" do
    it "returns the representation" do
      expect(
        Out.from_representation(payload).to_representation
      ).to eq(payload)
    end
  end
end
