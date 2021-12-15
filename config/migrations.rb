#!/usr/bin/ruby

require 'pg'

module Migrations
  # @return <Array>, first value is either the migrations is successful/failed,
  # second value is the error
  def self.run
    con = PG.connect dbname: 'umai_blog', user: 'postgres'

    con.exec 'CREATE TABLE IF NOT EXISTS users (
      id serial PRIMARY KEY,
      email varchar(45) NOT NULL,
      password varchar(450) NOT NULL
    )'

    con.exec 'CREATE TABLE IF NOT EXISTS posts (
      id serial PRIMARY KEY,
      user_id bigint,
      title varchar NOT NULL,
      content text NOT NULL,
      ip_address cidr NOT NULL,
      avg_rating numeric(2, 1) default 0.0
    )'

    con.exec 'CREATE TABLE IF NOT EXISTS ratings (
      id serial PRIMARY KEY,
      user_id bigint,
      post_id bigint,
      rate smallint NOT NULL
    )'

    con.exec 'CREATE TABLE IF NOT EXISTS feedbacks (
      id serial PRIMARY KEY,
      owner_id bigint NOT NULL,
      comment text NOT NULL,
      feedbackable_type varchar(70) NOT NULL,
      feedbackable_id bigint NOT NULL,
      user_email varchar(45),
      post_rating numeric(2,1)
    )'

    [true, nil]
  rescue PG::Error => e
    error = <<-ERRMSG
      #{e.message}
      Run 'sudo -u postgres createdb umai_blog --owner postgres'
    ERRMSG

    [false, error]
  ensure
    con&.close if con
  end
end
