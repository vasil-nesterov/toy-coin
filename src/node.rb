require "roda"

class Node < Roda
  plugin :json

  route do |r|
    blockchain = env['blockchain'] or raise "Blockchain not injected"

    r.get "blockchain" do
      { blockchain: blockchain.to_h }
    end

    r.post "mine" do
      miner = Miner.new(blockchain:, complexity: 5)
      miner.mine_next_block

      { 
        status: "success",
        blockchain: blockchain.to_h
      }
    end
  end
end
