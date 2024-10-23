# typed: strict

require "roda"

module Web
  class PublicInterface < Roda
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      node = T.let(
        (r.env['node'] or raise "Node not injected"), 
        Node
      )

      r.get "state" do
        { status: "success", state: node.to_representation }
      end
    end
  end
end