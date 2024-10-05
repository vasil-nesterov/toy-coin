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
        params = JSON.parse(r.body.read)

        amount = params["amount"].to_f
        
        if wallet.balance >= amount
          wallet.send_coins(params["recipient"], amount)
          { status: "success", balance: wallet.balance }          
        else
          { status: "error", error: "Not enough coins", balance: wallet.balance }
        end
      end

      r.post "mine" do
        wallet.instance_variable_get(:@node).mine_next_block
        { status: "success", state: wallet.instance_variable_get(:@node).to_h }
      end
    end
  end
end