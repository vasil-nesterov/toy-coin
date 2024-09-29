require 'json'
class BlockchainStorage
  attr_reader :path_to_file
  
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  def load
    raw_data = File.read(path_to_file)
    blocks = JSON
      .parse(raw_data)
      .map { |block_hash| Block.from_h(block_hash) }

    Blockchain.new(blocks)
  end

  # Temporary method; until the network is up and somewhat stable
  def load_or_init
    if File.exist?(path_to_file)
      load
    else
      # TODO: Replace with a logger
      warn "Blockchain file not found. Initializing with genesis block."

      bc = Blockchain.new([Block.genesis])
      save(bc)
      bc
    end
  end

  def save(blockchain)
    File.write(
      path_to_file, 
      JSON.pretty_generate(blockchain.to_h)
    )
  end
end
