module Nutrition
  class Breakdown < ActiveRecord::Base
    belongs_to :user
    validates :user, presence: true
    validates :date, presence: true
  end
end
