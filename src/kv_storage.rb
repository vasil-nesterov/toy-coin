# typed: strict

# TODO: Rename to KVStorage
class KvStorage
  extend T::Sig

  sig { params(path: String).void }
  def initialize(path)
    @path = path
  end

  # TODO: refactor
  sig { params(key: String).returns(String) }
  def fetch(key)
    File.read(@path).split("\n").each_with_object({}) do |line, hash|
      k, v = line.split('=')
      hash[k] = v
    end.fetch(key)
  end

  sig { params(hash: T::Hash[String, String]).void }
  def write(hash)
    hash
      .map { |k, v| "#{k}=#{v}" }
      .join("\n")
      .then { |content| File.write(@path, content) }
  end
end
