class Product < ActiveRecord::Base

  self.inheritance_column = nil # because we have a column "type"
  
  validates_presence_of :name
  validates_presence_of :upc
  validates_uniqueness_of :upc
  
  has_many :images, as: :imageable
  has_many :favourites, as: :favouritable
  has_many :places, as: :placeable
  has_many :users, through: :favourites

  validates :type, inclusion: { in: %w( breakfast lunch dinner snack ),
    message: "%{value} is not a valid meal type" }, allow_nil: true
end
