require "roda"

class Node < Roda
  plugin :json

  route do |r|
    blockchain = env['blockchain'] or raise "Blockchain not injected"

    r.get "blockchain" do
      { blockchain: blockchain.as_json }
    end
  end
end
