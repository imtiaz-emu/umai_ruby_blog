require 'pg'
require 'active_record'

module Database
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'umai_blog',
      username: 'postgres',
      password: '',
      host: 'localhost',
      port: 5432
    )
  end
end
