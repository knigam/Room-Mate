class Group < ActiveRecord::Base
  has_many :items
  has_many :tasks
  has_and_belongs_to_many :users
end
