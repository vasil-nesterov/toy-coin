# typed: false
require 'dry-validation'
require 'sorbet-runtime'

class Transaction < T::Struct
  class Contract < Dry::Validation::Contract
    json do
      required(:sender).filled(:string)
      required(:recipient).filled(:string)
      required(:value).filled(:float, gt?: 0)
    end
  end

  prop :sender, String
  prop :recipient, String
  prop :value, Numeric

  def to_h
    serialize.sort.to_h # Stable output
  end
end