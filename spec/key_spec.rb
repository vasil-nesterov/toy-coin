# typed: strict

RSpec.describe PrivateKey do
  T.bind(self, T.untyped)

  context "when loading from a file" do
    let(:key) { PrivateKey.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }

    describe '.load_from_file' do
      it 'returns a PrivateKey instance' do
        expect(key).to be_a(PrivateKey)
      end
    end

    describe '#secret_hex' do
      it 'returns the secret hex' do
        expect(key.secret_hex).to eq('6205705ab4ea755c9ffa4dc5ba8a43b303f7bf362672b5e81f9647f7907462b9')
      end
    end

    describe '#public_hex' do
      it 'returns the public hex' do
        expect(key.public_hex).to eq('d490db58ad194931540e8bb7f41d5d72dcbbb1fb54a5c459450eb547561ff3ef')
      end
    end
  end
end
