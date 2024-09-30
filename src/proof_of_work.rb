# typed: true
require "digest"

class ProofOfWork
  MAX_AVAILABLE_PROOF = 32.then { |n| 2**(n * 8) }

  def self.digest(proof, previous_proof)
    Digest::SHA256.hexdigest("#{proof}>#{previous_proof}")
  end

  def initialize(complexity)
    @complexity = complexity
  end

  def next_proof(previous_proof)
    loop do
      possible_proof = rand(MAX_AVAILABLE_PROOF)
      return possible_proof if valid_proof?(possible_proof, previous_proof)
    end
  end

  def valid_proof?(proof, previous_proof)
    self.class.digest(proof, previous_proof).start_with?("0" * @complexity)
  end
end
