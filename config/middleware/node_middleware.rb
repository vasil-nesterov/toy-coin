# typed: true
class NodeMiddleware
  PATH_TO_BLOCKCHAIN_STORAGE = "#{ROOT_DIR}/data/blockchain.json"
  
  def initialize(app)
    @app = app
    @node_name = ENV.fetch("NODE_NAME")
    @private_key = Key.load_from_file("#{ROOT_DIR}/data/keys/#{@node_name}.key")
    
    @node = Node.new(
      node_name: @node_name,
      private_key: @private_key,
      blockchain_storage: BlockchainStorage.new(PATH_TO_BLOCKCHAIN_STORAGE)
    )
  end

  def call(env)
    env['node'] = @node
    @app.call(env)
  end
end