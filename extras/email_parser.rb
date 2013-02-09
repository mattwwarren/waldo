#!/usr/bin/ruby

require 'rubygems'  
require 'active_record'
require 'chronic'
ActiveRecord::Base.establish_connection(  
:adapter => "sqlite3",
:database => "db/waldo_dev",
:encoding => "utf8"
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
active_date = Date.new
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

if subject.match(/(today|tomorrow|next \w+|this \w+)/i)
  active_date = Chronic.parse($1)
else
  active_date = Date.today
end

name = from.partition("<")[0]
emailaddr = from.partition("<")[2][0...-1]
notes = messagetext.join(" ")

Users.create(:name => name, :email => emailaddr, :status => subject, :notes => notes, :active_date => active_date)
