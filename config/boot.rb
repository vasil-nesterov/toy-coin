# typed: strict

require 'dotenv'
require 'sorbet-runtime'
require 'zeitwerk'

ROOT_DIR = T.let(File.expand_path('../..', __FILE__), String)

Dir.glob("#{ROOT_DIR}/src/core_extensions/*.rb").each do |file|
  require(file)
end

$loader = Zeitwerk::Loader.new
%w[config/middleware
   src/structs
   src/rules
   src].each { |dir| $loader.push_dir(dir) }
$loader.inflector.inflect("kv_storage" => "KVStorage")
$loader.enable_reloading
$loader.setup

env_files = %w[.env]
env_files.prepend('.env.test') if ENV['RSPEC'] == 'true'
Dotenv.load(*env_files)
