# typed: ignore

require 'rackup'
require_relative '../config/boot'
require_relative '../config/middleware/node_middleware'
require 'puma'
require 'puma/server'

PATH_TO_BLOCKCHAIN_STORAGE = "#{ROOT_DIR}/data/blockchain.json"
blockchain_storage = BlockchainStorage.new(PATH_TO_BLOCKCHAIN_STORAGE)

def run_app(app, port)
  server = Puma::Server.new(app)
  server.add_tcp_listener "127.0.0.1", port
  server.run
end

node_name = ENV.fetch("NODE_NAME")
private_key = Key.load_from_file("#{ROOT_DIR}/data/keys/#{node_name}.key")

node = Node.new(
  node_name: node_name,
  private_key: private_key,
  blockchain_storage: blockchain_storage
)
wallet = Wallet.new(node: node, key: private_key)

run_app(
  Rack::Builder.new do
    use NodeMiddleware, node
    run Web::PublicInterface.app
  end.to_app, 
  7001)

wallet_app = Rack::Builder.new do
  use WalletMiddleware, wallet
  run Web::PrivateInterface.app
end.to_app
run_app(wallet_app, 7002)

sleep