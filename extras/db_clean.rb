#!/usr/bin/ruby

require 'rubygems'  
require 'active_record'
require 'chronic'
ActiveRecord::Base.establish_connection(  
:adapter => "sqlite3",
:database => "db/development.sqlite3",
:encoding => "utf8"
)

class Users < ActiveRecord::Base
end

@users = Users.all
@today = Date.today
@users.each do |user|
  if user.active_date.to_date < @today
    Users.find(user.id).destroy
  end
end
