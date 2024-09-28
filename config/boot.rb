require "zeitwerk"
require_relative "../config/boot"

$loader = Zeitwerk::Loader.new
$loader.push_dir("src")
$loader.enable_reloading
$loader.setup

def reload!
  $loader.reload
end
