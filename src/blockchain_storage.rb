# typed: strict

require 'json'

class BlockchainStorage
  extend T::Sig
  include Logging

  sig { params(path_to_file: String).void }
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  sig { params(blockchain: Blockchain).void }
  def save(blockchain)
    File.write(
      @path_to_file,
      JSON.pretty_generate(blockchain.serialize)
    )
    logger.info("Written #{@path_to_file}")
  end

  # sig { returns(Blockchain) }
  # def load
  #   data = JSON.parse(File.read(path_to_file))

  #   complexity = ENV.fetch('COMPLEXITY').to_i
  #   raise "Blockchain complexity doesn't match ENV" unless complexity == data['complexity']

  #   bc = Blockchain.new(complexity)

  #   data['blocks'].each do |block_hash| 
  #     bc.add_block(
  #       Block.from_h(block_hash)
  #     )
  #   end

  #   bc
  # end

  # # Temporary method; until the network is up and somewhat stable
  # sig { returns(Blockchain) }
  # def load_or_init
  #   if File.exist?(path_to_file)
  #     load
  #   else
  #     # TODO: Replace with a logger
  #     warn "Blockchain file not found. Initializing with genesis block."

  #     bc = Blockchain.new(ENV.fetch('COMPLEXITY').to_i)
  #     bc.add_block(Block.new_genesis)
  #     save(bc)
  #     bc
  #   end
  # end
end
