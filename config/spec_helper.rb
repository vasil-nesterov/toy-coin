# typed: strict

require 'debug'

extend T::Sig

ENV['RSPEC'] = 'true'

Log = Logger.new(STDOUT, level: Logger::WARN)

RSpec.configure do |c|
  c.filter_run(focus: true)
  c.run_all_when_everything_filtered = true
end

sig { returns(Blockchain) }
def simple_blockchain
  bc, _utxo_set = BlockchainStorage
    .new("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json")
    .read
    
  bc
end

sig { returns(Tx) }
def simple_coinbase_tx
  File
    .read("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") 
    .then { |json| JSON.parse(json) }
    .then { |hash| hash.dig(0, "txs", 0) }
    .then { |tx| TxSerializer.from_representation(tx) }
end
