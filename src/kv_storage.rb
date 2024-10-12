# typed: strict

class KVStorage
  extend T::Sig
  include Logging

  sig { params(path: String).void }
  def initialize(path)
    @path = path
  end

  # TODO: keep hash in memory
  sig { params(key: String).returns(String) }
  def fetch(key)
    doc = File.read(@path)

    hash = doc
      .split("\n")
      .map { _1.split('=') }
      .to_h
    hash.fetch(key)
  end

  sig { params(hash: T::Hash[String, String]).void }
  def write(hash)
    doc = hash
      .map { |key, value| "#{key}=#{value}" }
      .join("\n")

    File.write(@path, doc)
    logger.info("Written #{@path}")
  end
end

