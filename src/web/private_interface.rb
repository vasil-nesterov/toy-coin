# typed: false

require "roda"

module Web
  class PrivateInterface < Roda
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      node = env['node'] or raise "Node not injected"
      
      r.post "mine" do
        node.mine_next_block
        { status: "success", state: node.to_h }
      end
    end
  end
end