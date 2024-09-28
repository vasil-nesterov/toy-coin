class Blockchain
  def initialize
    @blocks = [Block.genesis]
  end

  def as_json
    @blocks.map(&:as_json)
  end
end
