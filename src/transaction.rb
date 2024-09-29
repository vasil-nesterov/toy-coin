require 'dry-struct'
require 'dry-validation'
require_relative 'types'

class Transaction < Dry::Struct  
  attribute :sender, Types::String
  attribute :recipient, Types::String
  attribute :value, Types::Float

  class Contract < Dry::Validation::Contract
    json do
      required(:sender).filled(:string)
      required(:recipient).filled(:string)
      required(:value).filled(:float, gt?: 0)
    end
  end
end