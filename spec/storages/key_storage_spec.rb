# typed: strict

RSpec.describe KeyStorage do
  T.bind(self, T.untyped)

  let(:key_storage) { KeyStorage.new(path) }

  describe '#read' do
    let(:path) { "#{ROOT_DIR}/spec/fixtures/alice_test.key" }

    it 'returns a hash with private and public keys' do
      result = key_storage.read

      expect(result[:private_key]).to be_a(PrivateKey)
      expect(result[:public_key]).to be_a(PublicKey)
    end
  end

  describe '#write' do
    let(:path) { 'tmp/test.key' }
    let(:private_key) { PrivateKey.new("1627ad3d56989d4c0f70ac96f2548c032f46cfb28dafd0f9feefb90bbd7ddab7") }

    it 'writes the private key to the file' do
      File.delete(path) if File.exist?(path)

      key_storage.write(private_key)

      expect(File.read(path)).to eq(
        File.read("#{ROOT_DIR}/spec/fixtures/alice_test.key")
      )
    end
  end
end
