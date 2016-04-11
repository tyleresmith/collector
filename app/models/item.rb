class Item < ActiveRecord::Base
  belongs_to :collection

  include Slugifiable
  extend Slugifiable
end