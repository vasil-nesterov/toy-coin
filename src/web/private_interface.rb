# typed: strict

require "roda"

module Web
  class PrivateInterface < Roda
    extend T::Sig
    
    plugin :json
    plugin :error_handler do |e|
      { status: "error", error: e.message }
    end

    route do |r|
      wallet = r.env['wallet'] or raise "Wallet not injected"

      r.get "info" do
        { status: "success", wallet: wallet.to_h }
      end

      r.post "send_coins" do
        params = JSON.parse(r.body.read)

        amount = params["amount"].to_f
        
        if wallet.balance >= amount
          wallet.send_coins(params["recipient"], amount)
          { status: "success", wallet: wallet.to_h }          
        else
          { status: "error", error: "Not enough coins", wallet: wallet.to_h }
        end
      end

      r.post "mine" do
        wallet.mine_next_block
        { status: "success", wallet: wallet.to_h }
      end
    end
  end
end