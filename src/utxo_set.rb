# typed: strict

# TODO: Use a DB with 2 indexes under the hood. Clickhouse, RedisSearch, whatever.
class UTXOSet
  extend T::Sig

  sig { void }
  def initialize
    @utxos = T.let(Set.new, T::Set[UTXO])
  end

  sig { params(address: String).returns(Integer) }
  def balance_for(address)
    find_by_dest_address(address).sum(&:millis)
  end

  sig { params(block: Block).void }
  def process_block(block)
    block.txs.each do |tx|
      process_transaction(tx)
    end
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