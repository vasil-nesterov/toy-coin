# typed: strict

class WalletMiddleware
  extend T::Sig

  sig { params(app: Proc, wallet: Wallet).void }
  def initialize(app, wallet)
    @app = app
    @wallet = wallet
  end

  sig { params(env: T::Hash[String, T.untyped]).returns(T.untyped) }
  def call(env)
    env['wallet'] = @wallet
    @app.call(env)
  end
end