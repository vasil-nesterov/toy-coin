# typed: false

require 'sorbet-runtime'

class InputRuleSet
  extend T::Sig

  sig { params(input: Input).void }
  def initialize(input)
    @input = input
  end

  sig { returns(T::Boolean) }
  def satisfied?
    tx_id_correct? && out_i_correct?
  end

  private

  sig { returns(T::Boolean) }
  def tx_id_correct?
    @input.tx_id.to_bytes.length == 32
  end

  sig { returns(T::Boolean) }
  def out
    @input.out_i >= 0
  end
end