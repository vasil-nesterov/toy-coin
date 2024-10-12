# typed: false

RSpec.describe KVStorage do
  context 'with alice_test.key' do
    let(:storage_path) { 'spec/fixtures/alice_test.key' }
    let(:storage) { KVStorage.new(storage_path) }

    describe '#fetch' do
      it 'fetches the correct value for a given key' do
        expect(storage.fetch('SECRET')).to eq('870fb14056d582ad520033376230ab44f1da2bce678e4ea1a97fc9fd39f7cb89')
        expect(storage.fetch('PUBLIC')).to eq('927048e09be0cd155c2e21a6dbcf5e9707e71b521d989ffae65bce5277057737')
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
