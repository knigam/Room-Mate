class Group < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_and_belongs_to_many :users
end
