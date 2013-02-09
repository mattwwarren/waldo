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

to_delete = Users.find_all_by_active_date(Date.yesterday)
to_delete.each do |user|
  Users.find(user.id).destroy
end
