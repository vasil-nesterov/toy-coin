# typed: strict

require 'forwardable'

class Blockchain
  InvalidBlockAddedError = Class.new(StandardError)

  extend T::Sig

  sig { void }
  def initialize
    @blocks = T.let([], T::Array[Block])
    @utxo_pool = T.let(UtxoPool.new, UtxoPool)
  end
  
  # TODO: Move to BlockchainSerializer
  sig { returns(T::Array[T::Hash[String, T.untyped]]) }
  def serialize
    @blocks.map { |block| BlockSerializer.new(block).full_hash }
  end

  sig { params(next_block: Block).void }
  def add_block(next_block)
    @blocks << next_block

    # if BlockValidator.new(next_block, @blocks.last).call
    #   @blocks << next_block
    #   @utxo_pool.process_block(next_block)
    # else
    #   raise InvalidBlockAddedError, "Block #{next_block.to_hash} is invalid"
    # end
  end
end
