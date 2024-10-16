# typed: strict

require "ed25519"
require "digest/blake3"
require "dotenv"
require "sorbet-runtime"
require "time"
require "zeitwerk"

ROOT_DIR = T.let(File.expand_path("../..", __FILE__), String)
BLOCKCHAIN_FILE_PATH = T.let("#{ROOT_DIR}/data/blockchain.json", String)

Dir.glob("#{ROOT_DIR}/src/core_ext/*.rb").each do |file|
  require(file)
end

$loader = Zeitwerk::Loader.new
%w[config/middleware
   src/structs
   src/rules
   src].each { |dir| $loader.push_dir(dir) }
$loader.inflector.inflect(
  "kv_storage" => "KVStorage",
  "utxo" => "UTXO",
  "utxo_set" => "UTXOSet"
)
$loader.enable_reloading
$loader.setup

env_files = %w[.env]
env_files.prepend(".env.test") if ENV["RSPEC"] == "true"
Dotenv.load(*env_files)
