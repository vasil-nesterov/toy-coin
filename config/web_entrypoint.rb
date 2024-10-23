# typed: ignore

require 'rackup'
require 'puma'
require 'puma/server'

require_relative '../config/boot'

PATH_TO_BLOCKCHAIN_STORAGE = "#{ROOT_DIR}/data/blockchain.json"
blockchain_storage = BlockchainStorage.new(PATH_TO_BLOCKCHAIN_STORAGE)

node_name = ENV.fetch("NODE_NAME") or raise "NODE_NAME is not set"
private_key = KeyStorage.new("#{ROOT_DIR}/data/keys/#{node_name}.key").read[:private_key]

node = Node.new(blockchain_storage:)
wallet = Wallet.new(node:, private_key:)

def run_app(app, port)
  server = Puma::Server.new(app)
  server.add_tcp_listener "127.0.0.1", port
  server.run
end

node_app = Rack::Builder.new do
  use NodeMiddleware, node
  run Web::PublicInterface.app
end.to_app
run_app(node_app, 7001)

wallet_app = Rack::Builder.new do
  use WalletMiddleware, wallet
  run Web::PrivateInterface.app
end.to_app
run_app(wallet_app, 7002)

sleep