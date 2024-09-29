class NodeMiddleware
  PATH_TO_BLOCKCHAIN_STORAGE = "#{ROOT_DIR}/data/blockchain.json"
  def initialize(app)
    @app = app
    
    @node = Node.new(
      BlockchainStorage.new(PATH_TO_BLOCKCHAIN_STORAGE)
    )
  end

  def call(env)
    env['node'] = @node
    @app.call(env)
  end
end