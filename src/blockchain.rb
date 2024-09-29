require 'forwardable'

class Blockchain
  extend Forwardable

  protected attr_reader :blocks
  def_delegator :blocks, :length

  def initialize(blocks)
    @blocks = blocks
  end

  def ==(other)
    blocks == other.blocks
  end

  def to_h
    blocks.map(&:to_h_with_digest)
  end

  def add_block(block)
    blocks << block
  end

  def last_block
    blocks.last
  end
end
