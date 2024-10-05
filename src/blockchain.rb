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
    if BlockValidator.new(next_block, last_block).call
      @blocks << next_block
      @balance_registry.process_block(next_block)
    else
      raise InvalidBlockAddedError, "Block #{next_block.to_h_with_digest} is invalid"
    end
  end

  sig { returns(T.nilable(Block)) }
  def last_block
    @blocks.last
  end
end
