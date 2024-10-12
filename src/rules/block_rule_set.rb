# typed: strict

class BlockRuleSet
  extend T::Sig

  sig { returns(T::Array[String]) }
  attr_reader :errors

  sig { params(block: Block, complexity: Integer).void }
  def initialize(block, complexity:)
    @block = T.let(block, Block)
    @complexity = T.let(complexity, Integer)

    @errors = T.let([], T::Array[String])
  end

  sig { returns(T::Boolean) }
  def satisfied?
    block_digest_satisfies_complexity &&
      block_has_single_coinbase_tx
  end

  private

  sig { returns(T::Boolean) }
  def block_digest_satisfies_complexity
    hex = BlockDigest.new(@block).hex

    if hex.start_with?("0" * @complexity)
      true
    else
      @errors << "Block digest does not satisfy complexity"
      false
    end
  end

  sig { returns(T::Boolean) }
  def block_has_single_coinbase_tx
    number_of_coinbase_txs = @block.sig_txs.select { _1.tx.coinbase? }.count

    if number_of_coinbase_txs == 1
      true
    else
      @errors << "Block has #{number_of_coinbase_txs} coinbase txs, expected 1"
      false
    end
  end
end
