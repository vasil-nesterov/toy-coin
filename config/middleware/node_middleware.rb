# typed: false

class NodeMiddleware
  extend T::Sig

  sig { params(app: Proc, node: Node).void }
  def initialize(app, node)
    @app = app
    @node = node
  end

  sig { params(env: T::Hash[String, T.untyped]).returns(T.untyped) }
  def call(env)
    env['node'] = @node
    @app.call(env)
  end
end