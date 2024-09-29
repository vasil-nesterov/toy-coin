require "zeitwerk"

ROOT_DIR = File.expand_path('../..', __FILE__)

$loader = Zeitwerk::Loader.new
$loader.push_dir("src")
$loader.enable_reloading

$loader.setup

def reload!
  $loader.reload
end