# typed: strict

class Blockchain
  InvalidBlockAddedError = Class.new(StandardError)

  extend T::Sig

  sig { void }
  def initialize
    @complexity = T.let(nil, T.nilable(Integer))

    @blocks = T.let([], T::Array[Block])
    @utxo_set = T.let(UTXOSet.new, UTXOSet)
  end

  sig { returns(Integer) }
  def height
    @blocks.count
  end
  
  # TODO: Move to BlockchainSerializer
  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def serialize
    @blocks.map { |block| BlockSerializer.new(block).full_representation }
  end

  sig { params(next_block: Block).void }
  def add_block(next_block)
    # The first block must define .chain_tweaks.complexity
    read_complexity_from_block(next_block) if @blocks.empty?

    brs = BlockRuleSet.new(
      complexity: T.must(@complexity), block: next_block, previous_block: @blocks.last
    )
    if brs.satisfied?
      @blocks << next_block
      @utxo_set.process_block(next_block)
    else
      raise InvalidBlockAddedError, "Block is invalid: #{brs.errors.join("\n")}"
    end
  end

  sig { returns(Integer) }
  def current_complexity
    @complexity
  end

  sig { returns(String) }
  def last_block_dgst
    last_block = @blocks.last
    
    if last_block
      BlockDigest.new(last_block).hex
    else
      ''
    end
  end

  private

  sig { params(block: Block).void }
  def read_complexity_from_block(block)
    # TODO: Refactor
    @complexity = block.chain_tweaks&.fetch(:complexity, nil)
  end
end
