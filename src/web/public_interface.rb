# typed: false

require "roda"

module Web
  class PublicInterface < Roda
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      node = env['node'] or raise "Node not injected"

      r.get "state" do
        { status: "success", state: node.to_h }
      end

      r.post "transactions" do
        raw_transaction = JSON.parse(r.body.read)
        transaction = Transaction.from_h(raw_transaction)

        if node.add_transaction_to_mempool(transaction)
          { status: "success", state: node.to_h }
        else
          { status: "error", error: validation_result.errors.to_h.to_s }
        end
      end
    end
  end
end