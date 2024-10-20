# typed: strict

RSpec.describe KVStorage do
  T.bind(self, T.untyped)

  let(:storage) { KVStorage.new(storage_path) }

  describe '#read' do
    let(:storage_path) { 'spec/fixtures/alice_test.key' }

    it 'loads hash from file' do
      expect(storage.read).to eq({
        "SECRET" => "1627ad3d56989d4c0f70ac96f2548c032f46cfb28dafd0f9feefb90bbd7ddab7",
        "PUBLIC" => "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c"
      })
    end
  end

  describe '#write' do
    let(:storage_path) { 'tmp/test.key' }

    it 'writes the correct value for a given key' do
      storage.write({
        "SECRET" => "foo",
        "PUBLIC" => "bar"
      })

      expect(
        File.read(storage_path)
      ).to eq("SECRET=foo\nPUBLIC=bar")
    end
  end
end
