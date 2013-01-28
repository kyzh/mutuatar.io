$LOAD_PATH.unshift *Dir["#{File.dirname(__FILE__)}"]
require 'mutuatario'
#set :environment, :production
run Sinatra::Application
