#! /usr/bin/env ruby
# This script should (with the correct modifications), import users into your database
# Set binddn, bindpw, ldaphost, basedn and filter for your organization

binddn = "username@mycompany.com"
bindpw = "secret"
ldaphost = "dc.mycompany.com"
basedn = "DC=mycompany,DC=com"
filter = Net::LDAP::Filter.eq("displayName", "*")

ldap = Net::LDAP.new(:host => "dc.mycompany.com", :port => 389)
if ldap.bind(:method => :simple, :username => "username@mycompany.com", :password => "secret")
else
  p ldap.get_operation_result
end

begin
# Build the list
attrs = ["givenName", "email", "sAMAccountName"]
records = new_records = 0
ldap.search(:base => "DC=mycompany,DC=com", :attributes => attrs, :filter =>  filter,  :return_result => false) do |entry|
  name = entry.givenName.to_s.strip + " " + entry.sn.to_s.strip
  username = entry.sAMAccountName.to_s.strip
  email = entry.sAMAccountName.to_s.strip + "@mycompany.com"
  user = User.find_or_initialize_by_username :name => name, :username => username, :email => email, :office => office
  if user.new_record?
    user.save
    Points.find_or_create_by_user_id(user.id)
    new_records = new_records + 1
  else
    user.touch
  end
  records = records + 1
end
p ldap.get_operation_result

  logger.info( "LDAP Import Complete: " + Time.now.to_s )
  logger.info( "Total Records Processed: " + records.to_s )
  logger.info( "New Records: " + new_records.to_s )

  end

end
