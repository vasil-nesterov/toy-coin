class Blockchain
  attr_reader :blocks
  
  def initialize
    @blocks = [Block.genesis]
  end

  def to_h
    blocks.map(&:to_h)
  end

  def add_block(block)
    blocks.unshift(block)
  end

  def last_block
    blocks.first
  end
end
