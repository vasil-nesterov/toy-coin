# typed: strict

# TODO 
#   Use 2 indexes under the hood: on top of Clickhouse, RedisSearch, 
#   internal in-mem sturcture, whatever.
class UTXOSet
  extend T::Sig

  sig { void }
  def initialize
    @utxos = T.let(Set.new, T::Set[UTXO])
  end

  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def to_representation
    @utxos.map(&:to_representation)
  end

  sig { params(address: String).returns(Integer) }
  def balance_for(address)
    find_by_dest_address(address).sum(&:millis)
  end

  sig { params(address: String).returns(T::Array[UTXO]) }
  def utxos_for(address)
    find_by_dest_address(address)
  end

  sig { params(block: Block).void }
  def process_block(block)
    block.txs.each { process_transaction(_1) }
  end

  sig { params(tx: Tx).void }
  def process_transaction(tx)
    tx.ins.each do |input|
      unspent_output = find_by_tx_id_and_out_i(input.tx_id, input.out_i)
      raise "Unspent output not found" if unspent_output.nil?

      @utxos.delete(unspent_output)
    end

    tx.outs.each_with_index do |out, i|
      utxo = UTXO.new(
        tx_id: tx.dgst,
        out_i: i,
        dest_pub: out.dest_pub,
        millis: out.millis
      )

      Log.debug "utxo added: #{utxo.to_representation}"
      @utxos.add(utxo)
    end
  end

  private 

  sig { params(tx_id: String, out_i: Integer).returns(T.nilable(UTXO)) }        
  def find_by_tx_id_and_out_i(tx_id, out_i)
    @utxos.find { |utxo| utxo.tx_id == tx_id && utxo.out_i == out_i }
  end

  sig { params(address: String).returns(T::Array[UTXO]) }
  def find_by_dest_address(address)
    @utxos.select { |utxo| utxo.dest_pub == address }
  end
end