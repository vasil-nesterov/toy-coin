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
    logger.info("Saved blockchain to #{@path_to_file}")
  end

  sig { returns(Blockchain) }
  def load
    bc = Blockchain.new
    File.read(@path_to_file)
      .then { JSON.parse(_1) }
      .each { bc.add_block(Block.from_hash(_1)) }

    logger.info("Loaded blockchain from #{@path_to_file}")

    bc
  end
end
