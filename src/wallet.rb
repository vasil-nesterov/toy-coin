# typed: strict

# Wallet is initialized with a private key, and is responsible for:
#   - Checking the balance
#   - Sending coins 
# Adding to mempool is Node's responsibility

# TODO:
# - send_coins: set wits
# - connect to Node via HTTP

class Wallet
  extend T::Sig

  MINER_IDLE = T.let("idle".freeze, String)
  MINER_RUNNING = T.let("running".freeze, String)

  sig { params(node: Node, private_key: PrivateKey).void }
  def initialize(node:, private_key:)
    @node = node

    @private_key = private_key
    @public_key = T.let(private_key.public_key, PublicKey)
    
    @miner = T.let(nil, T.nilable(Thread))
  end

  sig { returns(T::Hash[String, T.untyped]) } 
  def to_h
    { address:, balance:, miner_status: }
  end

  sig { params(recipient_address: String, millis: Integer).void }
  def send_coins(recipient_address:, millis:)
    tx = Tx.new(
      dgst: "", 
      at: Time.now, 
      ins: [], 
      outs: [], 
      wits: []
    )

    utxos = utxos_to_cover(millis)

    utxos.each do |utxo|
      tx.ins << In.new(tx_id: utxo.tx_id, out_i: utxo.out_i)
    end

    tx.outs << Out.new(dest_pub: recipient_address, millis: millis)
    if utxos.sum(&:millis) > millis
      tx.outs << Out.new(dest_pub: address, millis: utxos.sum(&:millis) - millis)
    end

    @node.add_transaction_to_mempool(tx)
  end

  sig { returns(Thread) }
  def mine_next_block
    raise "Miner is already running" if miner_status == MINER_RUNNING

    @miner = Thread.new do
      # TODO: Save the key to a file. Later on, add Keychain abstraction over a group of private keys
      next_block, _coinbase_private_key = Miner.new(
        complexity: @node.blockchain_complexity,
        last_block_dgst: @node.last_block_dgst,
        public_key: @public_key
      ).next_block

      @node.add_block(next_block)
    end
  end

  sig { returns(Integer) }
  def balance
    @node.balance_for(@public_key.hex)
  end
  
  private

  sig { returns(String) }
  def address
    @public_key.hex
  end

  sig { returns(T::Array[UTXO]) }
  def utxos
    @node.utxos_for(address)
  end

  sig { params(millis: Integer).returns(T::Array[UTXO]) }
  def utxos_to_cover(millis)
    result = []
    
    utxos.each do |utxo|
      result << utxo
      break if result.sum(&:millis) >= millis
    end

    if result.sum(&:millis) < millis
      raise "Not enough balance"
    end

    result
  end

  sig { returns(String) }
  def miner_status
    if @miner&.alive?
      MINER_RUNNING
    else
      MINER_IDLE
    end
  end
end
