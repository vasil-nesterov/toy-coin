# typed: false

require "roda"

module Web
  class PrivateInterface < Roda
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      wallet = env['wallet'] or raise "Wallet not injected"

      r.get "balance" do
        { 
          status: "success", balance: wallet.balance
        }
      end

      r.post "send_coins" do
        raise "Not implemented"
      end

      r.post "mine" do
        node.mine_next_block
        { status: "success", state: node.to_h }
      end
    end
  end
end