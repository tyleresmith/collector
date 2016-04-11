class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :items

  include Slugifiable
  extend Slugifiable

end