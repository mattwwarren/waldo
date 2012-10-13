waldo
=====
Github URL: https://github.com/MattTheRat/waldo

Never wonder where your coworkers are again!

TODO
====

This is still in development.  These are the things I plan to do in the future.  If you have a request, please open a ticket on the github.

 - Check for existing email address before adding to the db
 - Cron script for removing all entries from db
 - LDAP account import

INSTALL
=======

I won't go into the details of setting up passenger right now but it's highly suggested for any production environment

Checkout this code into a location on your server.

To get the database set up, copy config/database.yml.example to config/database.yml and set database options appropriately

After setting up your database with correct permissions, run `rake db:migrate`
 - NOTE: If you are not running in "development", remember to set `RAILS_ENV=$environment` before running "rake"

To run locally or in development, run `rails server` from the root of the checkout.

For SENDMAIL servers:
 - place/link extras/email_parser.rb in /etc/smrsh
 - add alias for waldo in /etc/aliases
   - line should read: 
   - waldo:	"|/etc/smrsh/email_parser.rb"

UPGRADE
=======

Nothing yet.  I don't plan to mess with the database model too badly so code should be easily upgraded.
