#!/usr/bin/ruby

require 'rubygems'  
require 'active_record'  
ActiveRecord::Base.establish_connection(  
:adapter => "sqlite3",
:database => "db/waldo_dev",
:encoding => "utf8",
)

class Users < ActiveRecord::Base
end

message = Array.new
messagetext = Array.new
subject = String.new
from = String.new
name = String.new
emailaddr = String.new
notes = String.new
text_next = false

STDIN.each do |line|
  if line.match(/Subject: (.*)/)
    subject=$1
  elsif line.match(/From: (.*)/)
    from=$1
  elsif text_next == true
    messagetext.push(line.strip!)
  elsif line.match(/^\n/)
    text_next = true
  end
end

name = from.partition("<")[0]
emailaddr = from.partition("<")[2][0...-1]
notes = messagetext.join(" ")

Users.create(:name => name, :email => emailaddr, :status => subject, :notes => notes)
