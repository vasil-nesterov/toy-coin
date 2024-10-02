# typed: false

RSpec.describe Key do
  let(:hex) { '8af47d34a2beeec3766ec0223e32ded83060566678dc7638aa3dabd5bf784fb5' }
  let(:key) { Key.new(hex) }

  describe '.load_or_init_from_file' do
    it 'loads an existing key or creates a new one' do
      loaded_key = Key.load_or_init_from_file("#{ROOT_DIR}/spec/fixtures/test.key")

      expect(loaded_key).to be_a(Key)
      expect(loaded_key.to_hex).to eq("fef359681e0718da983cb19674c93683d1db7efebed262407cfbb5f0d5d9a14b")
    end

    it 'creates a new key if the file does not exist' do
      path = "#{ROOT_DIR}/spec/tmp/test.key"
      File.delete(path) if File.exist?(path)

      new_key = Key.load_or_init_from_file(path)

      expect(new_key).to be_a(Key)
      expect(new_key.to_hex.length).to eq(64)
    end
  end

  describe ".load_from_file" do
    let(:key) { Key.load_from_file("#{ROOT_DIR}/spec/fixtures/test.key") }

    it "loads an existing key" do
      expect(key).to be_a(Key)
      expect(key.to_hex).to eq("fef359681e0718da983cb19674c93683d1db7efebed262407cfbb5f0d5d9a14b")
    end
  end

  describe '#initialize' do
    it 'creates a Key instance with a valid private key' do
      expect(key).to be_a(Key)
    end
  end

  describe '#to_hex' do
    it 'returns the private key as a hex string' do
      expect(key.to_hex).to eq(hex)
    end
  end

  describe '#address' do
    it 'returns a non-empty string' do
      expect(key.address).to be_a(String)
      expect(key.address).not_to be_empty
    end
  end
end
