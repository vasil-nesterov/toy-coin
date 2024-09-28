require_relative '../../src/blockchain'

class ToyStateMiddleware
  def initialize(app)
    @app = app
    @blockchain = Blockchain.new
    @mempool = Mempool.new
  end

  def call(env)
    env['toy_state'] = { blockchain: @blockchain, mempool: @mempool }
    @app.call(env)
  end
end