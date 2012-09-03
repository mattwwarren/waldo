class User < ActiveRecord::Base
  attr_accessible :email, :name, :status
end
