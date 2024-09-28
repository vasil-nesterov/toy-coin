require "benchmark"

def b
  Benchmark.measure { yield }
end
