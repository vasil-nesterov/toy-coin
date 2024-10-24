# typed: strict

class BlockchainStorage
  extend T::Sig

  sig { params(path_to_file: String).void }
  def initialize(path_to_file)
    @path_to_file = path_to_file
  end

  # TODO: Refactor to return only a Blockchain. 
  # Computing UTXO for Node shouldn't be BlockchainStorage's responsibility.
  sig { returns([Blockchain, UTXOSet]) }
  def read
    bc = Blockchain.new
    utxo_set = UTXOSet.new

    File.read(@path_to_file)
      .then { JSON.parse(_1) }
      .map { BlockSerializer.from_representation(_1) }
      .each do |block|
        bc.add_block(block)
        utxo_set.process_block(block)
      end

    Log.info("Loaded blockchain from #{@path_to_file}")

    [bc, utxo_set]
  end

  sig { params(blockchain: Blockchain).void }
  def write(blockchain)
    File.write(
      @path_to_file,
      JSON.pretty_generate(blockchain.to_representation)
    )
    Log.info("Saved blockchain to #{@path_to_file}")
  end
end
