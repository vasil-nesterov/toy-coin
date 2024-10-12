# typed: strict

require "roda"

module Web
  class PublicInterface < Roda
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      node = r.env['node'] or raise "Node not injected"

      r.get "state" do
        { status: "success", state: node.to_h }
      end
    end
  end
end