class User < ActiveRecord::Base
  attr_accessible :email, :name, :status, :notes, :created_at, :updated_at
end
