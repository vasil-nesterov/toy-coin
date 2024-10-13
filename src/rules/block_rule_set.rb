# typed: strict

class BlockRuleSet
  extend T::Sig

  sig { returns(T::Array[String]) }
  attr_reader :errors

  sig { params(complexity: Integer, block: Block, previous_block: T.nilable(Block)).void }
  def initialize(complexity:, block:, previous_block: nil)
    @complexity = T.let(complexity, Integer)
    @block = T.let(block, Block)
    @previous_block = T.let(previous_block, T.nilable(Block))

    @errors = T.let([], T::Array[String])
  end

  # TODO: A better way to compose rules. BlockDigestSatisfiesComplexity is a great start.
  sig { returns(T::Boolean) }
  def satisfied?
    rules = [
      block_digest_satisfies_complexity, 
      block_has_single_coinbase_tx,
      txs_rules_satisfied
    ]

    if @previous_block
      rules << BlockReferencesPreviousBlock.new(block: @block, previous_block: @previous_block).satisfied?
    end

    rules.all?
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
    number_of_coinbase_txs = @block.txs.select { _1.coinbase? }.count
  
    if number_of_coinbase_txs == 1
      true
    else
      @errors << "Block has #{number_of_coinbase_txs} coinbase txs, expected 1"
      false
    end
  end

  sig { returns(T::Boolean) }
  def txs_rules_satisfied
    # coinbase_txs, regular_txs = @block.txs.partition(&:coinbase?)

    txs_rule_sets = @block.txs.map { TxRuleSet.new(_1) }

    if txs_rule_sets.all?(&:satisfied?)
      true
    else
      # TODO: errors
      false
    end
  end

  class BlockReferencesPreviousBlock
    extend T::Sig
    
    sig { params(block: Block, previous_block: Block).void }
    def initialize(block:, previous_block:)
      @block = block
      @previous_block = previous_block
    end

    sig { returns(T::Boolean) }
    def satisfied?
      @block.prev_dgst == BlockDigest.new(@previous_block).hex
    end
  end
end
