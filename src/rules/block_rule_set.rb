# typed: strict

class BlockRuleSet
  extend T::Sig

  sig { returns(T::Array[String]) }
  attr_reader :errors

  sig { params(block: Block, complexity: Integer, utxo_set: UTXOSet, previous_block: T.nilable(Block)).void }
  def initialize(block:, complexity:, utxo_set:, previous_block: nil)
    @complexity = T.let(complexity, Integer)
    @block = T.let(block, Block)
    @utxo_set = T.let(utxo_set, UTXOSet)
    @previous_block = T.let(previous_block, T.nilable(Block))

    @errors = T.let([], T::Array[String])
  end

  # TODO: A better way to compose rules. BlockDigestSatisfiesComplexity is a great start.
  sig { returns(T::Boolean) }
  def satisfied?
    @errors = []

    block_digest_satisfies_complexity
    block_has_single_coinbase_tx
    txs_rules_satisfied

    if @previous_block
      brpb = BlockReferencesPreviousBlock.new(block: @block, previous_block: @previous_block)
      unless brpb.satisfied?
        @errors = @errors.concat(brpb.errors)
      end
    end

    @errors.empty?
  end

  private

  sig { void }
  def block_digest_satisfies_complexity
    hex = BlockDigest.new(@block).hex

    unless hex.start_with?("0" * @complexity)
      @errors << "Block digest does not satisfy complexity"
    end
  end

  sig { void }
  def block_has_single_coinbase_tx
    number_of_coinbase_txs = @block.txs.select { _1.coinbase? }.count
  
    unless number_of_coinbase_txs == 1
      @errors << "Block has #{number_of_coinbase_txs} coinbase txs, expected 1"
    end
  end

  sig { void }
  def txs_rules_satisfied
    # coinbase_txs, regular_txs = @block.txs.partition(&:coinbase?)

    txs_rule_sets = @block.txs.map { TxRuleSet.new(tx: _1, utxo_set: @utxo_set) }
    
    unless txs_rule_sets.all?(&:satisfied?)
      @errors << "Block contains invalid transactions"
    end
  end

  class BlockReferencesPreviousBlock
    extend T::Sig
    
    sig { returns(T::Array[String]) }
    attr_reader :errors

    sig { params(block: Block, previous_block: Block).void }
    def initialize(block:, previous_block:)
      @block = block
      @previous_block = previous_block

      @errors = T.let([], T::Array[String])
    end

    sig { returns(T::Boolean) }
    def satisfied?
      @errors = []

      unless @block.prev_dgst == BlockDigest.new(@previous_block).hex
        @errors << "Block does not reference previous block"
      end

      @errors.empty?
    end
  end
end
