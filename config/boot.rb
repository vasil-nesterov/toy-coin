require "zeitwerk"
require_relative "../config/boot"

loader = Zeitwerk::Loader.new
loader.push_dir("src")
loader.setup
