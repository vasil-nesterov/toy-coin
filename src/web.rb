# typed: false
require "roda"

class Web < Roda
  plugin :json
  plugin :error_handler do |e|
    { status: "error", error: e.message }
  end

  route do |r|
    node = env['node'] or raise "Node not injected"

    r.get "state" do
      { status: "success", state: node.to_h }
    end

    r.post "mine" do
      node.mine_next_block
      { status: "success", state: node.to_h }
    end

    r.post "transactions" do
      raw_transaction = JSON.parse(r.body.read)
      validation_result = Transaction::Contract.new.call(raw_transaction)
      
      if validation_result.success? && node.add_transaction_to_mempool(Transaction.new(validation_result.to_h))
        { status: "success", state: node.to_h }
      else
        { status: "error", error: validation_result.errors.to_h.to_s }
      end
    end
  end
end
