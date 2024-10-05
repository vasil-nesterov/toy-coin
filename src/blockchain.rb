# typed: strict
# 
require 'forwardable'

class Blockchain
  InvalidBlockAddedError = Class.new(StandardError)

  extend T::Sig
  extend Forwardable

  sig { returns(BalanceRegistry) }
  attr_reader :balance_registry

  sig { params(complexity: Integer).void }
  def initialize(complexity)
    @complexity = complexity
    @blocks = T.let([], T::Array[Block])

    @balance_registry = T.let(BalanceRegistry.new, BalanceRegistry)
  end

  sig { returns(Integer) }
  attr_reader :complexity

  def_delegator :@blocks, :length
  
  sig { returns(T::Hash[String, T.untyped]) }
  def to_h
    {
      complexity: complexity,
      balance_registry: @balance_registry.to_h,
      blocks: @blocks.map(&:to_h_with_digest)
    }
  end

  sig { params(next_block: Block).void }
  def add_block(next_block)
    unless @blocks.empty?
      if next_block.previous_block_digest != last_block.digest
        msg = "Block #{next_block.to_h_with_digest} has invalid previous_block_digest. Previous block: #{last_block.to_h_with_digest}"
        raise InvalidBlockAddedError, msg
      end
  
      unless ProofOfWork.new(@complexity).valid_proof?(next_block.proof, last_block.proof)
        msg = "Block #{next_block.to_h_with_digest} has invalid proof"
        raise InvalidBlockAddedError, msg
      end
    end

    @blocks << next_block
    @balance_registry.process_block(next_block)
  end

  sig { returns(Block) }
  def last_block
    @blocks.last or raise "No blocks"
  end
end
