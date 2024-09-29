require_relative '../config/boot'
require_relative 'middleware/node_middleware'

use NodeMiddleware

run Web.app