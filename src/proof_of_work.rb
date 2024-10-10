# typed: strict

require "digest"

class ProofOfWork
  extend T::Sig

  # In the formula below, 32 is the number of bytes.
  MAX_AVAILABLE_PROOF = T.let((2 ** (32 * 8)).to_i, Integer)

  sig { params(proof: Integer, previous_proof: Integer).returns(String) }
  def self.digest(proof, previous_proof)
    Digest::SHA256.hexdigest("#{proof}>#{previous_proof}")
  end

  sig { params(complexity: Integer).void }
  def initialize(complexity)
    @complexity = complexity
  end

  sig { params(previous_proof: Integer).returns(Integer) }
  def next_proof(previous_proof)
    loop do
      possible_proof = rand(MAX_AVAILABLE_PROOF)
      return possible_proof if valid_proof?(possible_proof, previous_proof)
    end
  end

  sig { params(proof: Integer, previous_proof: Integer).returns(T::Boolean) }
  def valid_proof?(proof, previous_proof)
    self.class.digest(proof, previous_proof).start_with?("0" * @complexity)
  end
end
