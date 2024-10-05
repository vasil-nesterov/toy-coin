# typed: true

class WalletMiddleware
  extend T::Sig

  def initialize(app, wallet)
    @app = app
    @wallet = wallet
  end

  def call(env)
    env['wallet'] = @wallet
    @app.call(env)
  end
end