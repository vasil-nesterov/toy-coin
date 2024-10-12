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
    block_digest_satisfies_complexity?
  end

  private

  sig { returns(T::Boolean) }
  def block_digest_satisfies_complexity?
    hex = BlockDigest.new(@block).hex

    if hex.start_with?("0" * @complexity)
      true
    else
      @errors << "Block digest does not satisfy complexity"
      false
    end
  end
end
