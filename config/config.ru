require_relative 'middleware/toy_state_middleware'
require_relative '../config/boot'

use ToyStateMiddleware

run Web.app