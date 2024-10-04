# typed: true

class NodeMiddleware
  def initialize(app, node)
    @app = app
    @node = node
  end

  def call(env)
    env['node'] = @node
    @app.call(env)
  end
end