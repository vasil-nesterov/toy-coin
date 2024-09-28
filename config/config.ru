require_relative 'middleware/blockchain_middleware'
require_relative '../config/boot'

use BlockchainMiddleware

run Node.app