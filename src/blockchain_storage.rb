# typed: strict

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

  # TODO: Refactor to return only a Blockchain. 
  # Computing UTXO for Node shouldn't be BlockchainStorage's responsibility.
  sig { returns([Blockchain, UTXOSet]) }
  def load
    bc = Blockchain.new
    utxo_set = UTXOSet.new

    File.read(@path_to_file)
      .then { JSON.parse(_1) }
      .map { BlockSerializer.from_representation(_1) }
      .each do |block|
        bc.add_block(block)
        utxo_set.process_block(block)
      end

    logger.info("Loaded blockchain from #{@path_to_file}")

    [bc, utxo_set]
  end
end
