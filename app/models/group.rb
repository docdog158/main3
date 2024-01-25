class Group < ApplicationRecord
  #子を持たせる(じぶんは親)
  has_many :group_users, dependent: :destroy
  
  #グループへの入退場
  has_many :users, through: :group_users
  
  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end
  #end
  
  belongs_to :owner, class_name: 'User'
  
  #空文字を許可しない
  validates :name, presence: true
  validates :introduction, presence: true
  
  has_one_attached :group_image
  
  def is_owned_by?(user)
    owner.id == user.id
  end
end