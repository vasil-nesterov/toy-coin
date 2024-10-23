# typed: strict

ENV['RSPEC'] = 'true'

require 'debug'
require_relative '../config/boot'

extend T::Sig

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

sig { returns(Block) }
def simple_next_block
  BlockSerializer.from_representation({
    "ver" => 2,
    "prev_dgst" => "0b9f6c343f69404bd1159a0d9b5e8cac2cd685f3678240a2cd7605e49553b2dc",
    "nonce" => Integer("97299927747699677814947105619639348173856746760301077543280661566890515911924"),
    "txs" => [
      {
        "dgst" => "c62e1016d278aeb6fb2f69ec22b89621f16799cbe2c118cf25b86b98233bd293",
        "at" => "2024-10-23T18:17:57Z",
        "ins" => [],
        "outs" => [
          {
            "dest_pub" => "33060d2c78b2d40e529763f9e0cf901463ca2b8f75061412caded25a1382cc1c",
            "millis" => 1000
          }
        ],
        "wits" => []
      }
    ]
  })
end

sig { returns(Tx) }
def simple_coinbase_tx
  File
    .read("#{ROOT_DIR}/spec/fixtures/simple_blockchain.json") 
    .then { |json| JSON.parse(json) }
    .then { |hash| hash.dig(0, "txs", 0) }
    .then { |tx| TxSerializer.from_representation(tx) }
end
