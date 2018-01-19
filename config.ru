require_relative 'middleware/handler'
require_relative 'time'

use Handler
run Time.new