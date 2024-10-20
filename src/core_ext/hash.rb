# typed: strict

class Hash
  extend T::Sig

  sig { returns(T::Hash[String, T.untyped]) }
  def stabilize
    to_a.sort.map do |array|
      key, value = array

      case value
      when Hash
        [key, value.stabilize]
      else
        [key, value]
      end
    end.to_h
  end

  sig { returns(String) } 
  def to_stable_json
    stabilize.to_json
  end
end
