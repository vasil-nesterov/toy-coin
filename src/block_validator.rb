# typed: strict

class BlockValidator
  extend T::Sig

  sig { params(block: Block, previous_block: T.nilable(Block)).void }
  def initialize(block, previous_block)
    @block = block
    @previous_block = previous_block
  end

  sig { returns(T::Boolean) }
  def call
    result = [valid_transactions?]
    
    if @previous_block
      result << SubsequentBlockValidator.new(@block, @previous_block).call
    end

    result.all?
  end

  private

  sig { returns(T::Boolean) }
  def valid_transactions?
    @block.transactions.all? { |tx| TransactionValidator.new(tx).call }
  end

  class SubsequentBlockValidator
    extend T::Sig
  
    sig { params(block: Block, previous_block: Block).void }
    def initialize(block, previous_block)
      @block = block
      @previous_block = previous_block
    end
  
    sig { returns(T::Boolean) }
    def call
      valid_proof? && valid_previous_block_digest?
    end
  
    private
  
    sig { returns(T::Boolean) }
    def valid_proof?
      ProofOfWork.new(ENV.fetch('COMPLEXITY').to_i).valid_proof?(@block.proof, @previous_block.proof)
    end
  
    sig { returns(T::Boolean) }
    def valid_previous_block_digest?
      @block.previous_block_digest == @previous_block.digest
    end
  end
end