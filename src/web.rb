require "roda"

class Web < Roda
  plugin :json
  plugin :error_handler do |e|
    { status: "error", error: e.message }
  end

  route do |r|
    toy_state = env['toy_state'] or raise "Toy state not injected"
    blockchain, mempool = toy_state.values_at(:blockchain, :mempool)

    r.get "state" do
      {
        mempool: mempool.to_h,
        blockchain: blockchain.to_h
      }
    end

    r.get "blockchain" do
      { blockchain: blockchain.to_h }
    end

    r.get "mempool" do
      { mempool: mempool.to_h }
    end

    r.post "mine" do
      miner = Miner.new(blockchain:, complexity: 5)
      miner.mine_next_block(mempool: mempool)

      { 
        status: "success",
        blockchain: blockchain.to_h
      }
    end

    r.post "transactions" do
      raw_transaction = JSON.parse(r.body.read)
      validation_result = Transaction::Contract.new.call(raw_transaction)
      
      if validation_result.success?
        mempool.add_transaction(
          Transaction.new(validation_result.to_h)
        )
        { status: "success", mempool: mempool.to_h }
      else
        { status: "error", error: validation_result.errors.to_h.to_s }
      end
    end
  end
end
