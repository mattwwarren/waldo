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

message = Array.new
messagetext = Array.new
subject = String.new
from = String.new
name = String.new
emailaddr = String.new
notes = String.new
active_date = Date.new
subjects = Array.new
dates = Array.new
text_next = false

# Read in the email and parse out the lines we care about

STDIN.each do |line|
  if line.match(/Subject: (.*)/)
    subject=$1
  elsif line.match(/From: (.*)/)
    from=$1
  elsif text_next == true
    messagetext.push(line.sub(/=20/, '').strip!)
  elsif line.match(/^\n/)
    text_next = true
  end
end

# Remove leading whitespace to clean up formatting and 
# make further parsing easier

messagetext.delete_if {|s| s.empty?}

# Some (Most??) clients throw junk on the first line we get
# Trim that off and move on

if messagetext[0] =~ /--/
  messagetext.reverse!
  messagetext.pop
  messagetext.reverse!
end

# Next lines are content definitons, don't care

messagetext.delete_if {|s| s.include?("Content-")}

# Detect the end of the email by looking for a signature
# We only want text above that so strip it off

if messagetext.index {|s| s =~ /--\w*/}
  eom = messagetext.index {|s| s =~ /--\w*/} - 1
  messagetext = messagetext.slice(0..eom)
end

# Finally, parse through the other information we got
# These variables will be used for storing to the db

name = from.partition("<")[0]
emailaddr = from.partition("<")[2][0...-1]
notes = messagetext.join(" ")

# Handle multiple days off for the same reason
# Multiple matches will result in arrays of arrays
# Create a date we can use and save it to the db

subjects = subject.scan(/(today|tomorrow|next \w+|this \w+|mon\w*|tue\w*|wed\w*|thur\w*|fri\w*)/i)
if subjects.size > 0
  subjects.each do |dates|
    dates.each do |date|
      active_date = Chronic.parse(date)
      Users.create(:name => name, :email => emailaddr, :status => subject, :notes => notes, :active_date => active_date)
    end
  end
else
  active_date = Date.today
  Users.create(:name => name, :email => emailaddr, :status => subject, :notes => notes, :active_date => active_date)
end
