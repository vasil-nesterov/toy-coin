# typed: strict

require 'json'

class Hash
  extend T::Sig

  sig { returns(String) }
  def to_stable_json
    sort.to_h.to_json
  end
end
