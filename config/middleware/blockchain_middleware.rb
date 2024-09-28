require_relative '../../src/blockchain'

class BlockchainMiddleware
  def initialize(app)
    @app = app
    @blockchain = Blockchain.new
  end

  def call(env)
    env['blockchain'] = @blockchain
    @app.call(env)
  end
end