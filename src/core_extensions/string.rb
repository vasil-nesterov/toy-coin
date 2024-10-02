# typed: strict

require "sorbet-runtime"

class String
  extend T::Sig

  sig { returns(String) }
  def to_hex
    unpack("H*").first.to_s
  end

  sig { returns(String) }
  def to_bytes
    [self].pack("H*")
  end
end
