require "roda"

class Node < Roda
  plugin :json

  route do |r|
    blockchain = env['blockchain'] or raise "Blockchain not injected"

    r.get "blockchain" do
      { blockchain: blockchain.to_h }
    end

    r.post "mine" do
      last_block = blockchain.last_block
      proof = ProofOfWork.new(5).next_proof(last_block.proof)
      p proof
      new_block = Block.new(
        index: last_block.index + 1,
        timestamp: Time.now.utc,
        proof: proof,
        transactions: [],
        previous_block_digest: last_block.digest
      )

      blockchain.add_block(new_block)
    
      { 
        status: "success",
        blockchain: blockchain.to_h
      }
    end
  end
end
