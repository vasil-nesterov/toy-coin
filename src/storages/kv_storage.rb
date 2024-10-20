# typed: strict

class KVStorage
  extend T::Sig

  sig { params(path: String).void }
  def initialize(path)
    @path = path
  end

  sig { returns(T::Hash[String, String]) }
  def read
    hash = File
      .read(@path)
      .split("\n")
      .map { _1.split('=') }
      .to_h

    Log.info("Loaded #{@path}")
    hash
  end

  sig { params(hash: T::Hash[String, String]).void }
  def write(hash)
    doc = hash
      .map { |key, value| "#{key}=#{value}" }
      .join("\n")

    File.write(@path, doc)
    Log.info("Written #{@path}")
  end
end