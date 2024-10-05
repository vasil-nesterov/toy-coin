# typed: true
require 'json'

class BlockchainStorage
  attr_reader :path_to_file
  
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  def load
    data = JSON.parse(File.read(path_to_file))

    complexity = ENV.fetch('COMPLEXITY').to_i
    raise "Blockchain complexity doesn't match ENV" unless complexity == data['complexity']

    bc = Blockchain.new(complexity)

    # TODO: Refactor this mess
    data['blocks'].each do |block_hash| 
      block_attrs = Block::Contract.new.call(block_hash).to_h
      block_attrs[:transactions] = block_attrs[:transactions].map do |transaction_hash| 
        Transaction.from_hash(transaction_hash)
      end

      bc.add_block(Block.new(block_attrs))
    end

    bc
  end

  # Temporary method; until the network is up and somewhat stable
  def load_or_init
    if File.exist?(path_to_file)
      load
    else
      # TODO: Replace with a logger
      warn "Blockchain file not found. Initializing with genesis block."

      bc = Blockchain.new(ENV.fetch('COMPLEXITY').to_i)
      bc.add_block(Block.new_genesis)
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
