require 'rack'
require 'rack/handler/puma'
require 'pry'
require_relative './config/database'
require_relative './config/migrations'
require_relative './config/routes'
require_relative './config/seeds'
require 'action_dispatch'

class App
  include Database
  include Migrations

  def self.run
    Database.connect
    Migrations.run

    Rack::Handler::Puma.run(Routes.new.call, Port: 3000, Verbose: true)
  rescue StandardError => e
    puts e.message
  end
end


Seeds.call if ARGV.include?('seed')

App.run
