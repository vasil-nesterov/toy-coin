# typed: false

RSpec.describe KVStorage do
  context 'with alice_test.key' do
    let(:storage_path) { 'spec/fixtures/alice_test.key' }
    let(:storage) { KVStorage.new(storage_path) }

    describe '#fetch' do
      it 'fetches the correct value for a given key' do
        expect(storage.fetch('SECRET')).to eq('6205705ab4ea755c9ffa4dc5ba8a43b303f7bf362672b5e81f9647f7907462b9')
        expect(storage.fetch('PUBLIC')).to eq('d490db58ad194931540e8bb7f41d5d72dcbbb1fb54a5c459450eb547561ff3ef')
      end
    end
  end

  context 'with tmp key' do
    let(:storage_path) { 'tmp/test.key' }
    let(:storage) { KVStorage.new(storage_path) }

    describe '#write' do
      it 'writes the correct value for a given key' do
        storage.write({ 'SECRET' => 'foo', 'PUBLIC' => 'bar' })
        expect(File.read(storage_path)).to eq("SECRET=foo\nPUBLIC=bar")
      end
    end
  end
end
