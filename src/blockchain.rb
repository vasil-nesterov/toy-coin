# typed: false
require 'forwardable'

class Blockchain
  InvalidBlockAddedError = Class.new(StandardError)

  extend Forwardable

  def initialize(complexity)
    @complexity = complexity
    @blocks = []
  end

  protected attr_reader :blocks
  
  attr_reader :complexity
  def_delegator :blocks, :length
  
  def ==(other)
    blocks == other.blocks
  end

  def to_h
    {
      complexity: complexity,
      blocks: blocks.map(&:to_h_with_digest)
    }
  end

  def add_block(next_block)
    if blocks.empty?
      blocks << next_block
      return
    end

    if next_block.previous_block_digest != last_block.digest
      msg = "Block #{next_block.to_h_with_digest} has invalid previous_block_digest"
      raise InvalidBlockAddedError, msg
    end

    unless ProofOfWork.new(@complexity).valid_proof?(next_block.proof, last_block.proof)
      msg = "Block #{next_block.to_h_with_digest} has invalid proof"
      raise InvalidBlockAddedError, msg
    end

    blocks << next_block
  end

  def last_block
    blocks.last
  end
end
