class User < ActiveRecord::Base
  has_many :collections
  has_secure_password
  
  include Slugifiable
  extend Slugifiable
end