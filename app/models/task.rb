class Task < ActiveRecord::Base
  belongs_to :group
  has_and_belongs_to_many :users
end
