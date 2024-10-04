# typed: ignore

require 'rackup'
require_relative '../config/boot'
require_relative '../config/middleware/node_middleware'
require 'puma'
require 'puma/server'

PATH_TO_BLOCKCHAIN_STORAGE = "#{ROOT_DIR}/data/blockchain.json"

def run_app(klass, port, node)
  app = Rack::Builder.new do
    use NodeMiddleware, node
    run klass.app
  end.to_app

  server = Puma::Server.new(app)
  server.add_tcp_listener "127.0.0.1", port
  server.run
end

blockchain_storage = BlockchainStorage.new(PATH_TO_BLOCKCHAIN_STORAGE)

node_name = ENV.fetch("NODE_NAME")
private_key = Key.load_from_file("#{ROOT_DIR}/data/keys/#{node_name}.key")

node = Node.new(
  node_name: node_name,
  private_key: private_key,
  blockchain_storage: blockchain_storage
)

run_app(Web::PublicInterface, 7001, node)
run_app(Web::PrivateInterface, 7002, node)

sleep