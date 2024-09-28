require "zeitwerk"

$loader = Zeitwerk::Loader.new
$loader.push_dir("src")
$loader.enable_reloading

$loader.setup

def reload!
  $loader.reload
end
