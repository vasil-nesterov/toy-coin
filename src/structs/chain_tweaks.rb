# typed: strict

class ChainTweaks < T::Struct
  extend T::Sig

  prop :complexity, T.nilable(Integer)

  sig { params(payload: T.nilable(T::Hash[String, T.untyped])).returns(ChainTweaks) }
  def self.from_representation(payload)
    new(
      complexity: payload && payload["complexity"]&.to_i
    )
  end

  sig { returns(T.nilable(T::Hash[String, T.untyped])) }
  def to_representation
    result = {}
    result["complexity"] = complexity if complexity

    result.empty? ? nil : result
  end
end
