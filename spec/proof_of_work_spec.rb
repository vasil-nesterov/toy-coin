# typed: false

require "rspec"
require_relative "../src/proof_of_work"

describe ProofOfWork do
  let(:complexity) { 1 }
  let(:pow) { ProofOfWork.new(complexity) }

  describe ".digest" do
    it "returns the digest of the proof and previous proof" do
      expect(ProofOfWork.digest(35, 0)).to eq("0c3f78fba5399c309a2882d46cddbc8fca270bab448c680ee2561698d63ecd23")
    end
  end

  describe "#next_proof" do
    it "finds the next proof" do
      previous_proof = 0
      next_proof = pow.next_proof(previous_proof)
      
      expect(pow.valid_proof?(next_proof, previous_proof)).to be(true)
    end
  end

  describe "#valid_proof?" do
    it "validates a correct proof" do
      expect(pow.valid_proof?(35, 0)).to be(true)
    end

    it "rejects an invalid proof" do
      expect(pow.valid_proof?(0, 0)).to be(false)
    end
  end
end
