# typed: strict

class BlockDigestSatisfiesComplexity
  extend T::Sig

  sig { params(block: Block, complexity: Integer).void }
  def initialize(block:, complexity:)
    @block = block
    @complexity = complexity

    @errors = T.let([], T::Array[String])
  end

  sig { returns(T::Boolean) }
  def satisfied?
    @errors = []

    unless hex.start_with?("0" * @complexity)
      @errors << "Block digest does not satisfy complexity"
    end

    @errors.empty?
  end

  private

  sig { returns(String) }
  def hex
    BlockDigest.new(@block).hex
  end
end
