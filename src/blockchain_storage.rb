class BlockchainStorage
  attr_reader :path_to_file
  
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  def save(blockchain)
    File.write(
      path_to_file, 
      JSON.pretty_generate(blockchain.to_h)
    )
  end

  def load
    raw_data = File.read(path_to_file)
    blocks = JSON
      .parse(raw_data)
      .map { |block_hash| Block.from_h(block_hash) }

    Blockchain.new(blocks)
  end
end