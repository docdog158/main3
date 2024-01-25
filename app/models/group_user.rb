class GroupUser < ApplicationRecord
  #下記の親を持つ(子になる)
  belongs_to :user
  belongs_to :group
  
end
