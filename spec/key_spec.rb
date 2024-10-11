# typed: false

RSpec.describe Key do
  context "when loading from a file" do
    let(:key) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/alice_test.key") }

    describe '.load_from_file' do
      it 'returns a Key instance' do
        expect(key).to be_a(Key)
      end
    end

    describe '#secret_hex' do
      it 'returns the secret hex' do
        expect(key.secret_hex).to eq('870fb14056d582ad520033376230ab44f1da2bce678e4ea1a97fc9fd39f7cb89')
      end
    end

    describe '#public_hex' do
      it 'returns the public hex' do
        expect(key.public_hex).to eq('927048e09be0cd155c2e21a6dbcf5e9707e71b521d989ffae65bce5277057737')
      end
    end
  end
end
