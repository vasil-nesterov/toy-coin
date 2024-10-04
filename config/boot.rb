# typed: true
require 'dotenv'
require 'zeitwerk'

ROOT_DIR = File.expand_path('../..', __FILE__)

Dir.glob("#{ROOT_DIR}/src/core_extensions/*.rb").each do |file|
  require(file)
end

$loader = Zeitwerk::Loader.new
$loader.push_dir("config/middleware")
$loader.push_dir("src")
$loader.enable_reloading
$loader.setup

env_files = %w[.env]
env_files.prepend('.env.test') if ENV['RSPEC'] == 'true'
Dotenv.load(*env_files)
