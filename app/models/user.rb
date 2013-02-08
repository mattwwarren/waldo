class User < ActiveRecord::Base
  attr_accessible :email, :name, :status, :notes, :created_at, :updated_at

  validates :email, :presence => true, :uniqueness => true
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
end
