class Book < ApplicationRecord
  

  
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  has_many :post_comments, dependent: :destroy
  
  has_many :favorites, dependent: :destroy

  # 検索方法分岐
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('name LIKE ?', '%' + content)
    else
      Book.where('name LIKE ?', '%' + content + '%')
    end
  end
  
  #投稿数の前日比・前週比
  #scope :created_today, -> { where(created_at: Time.zone.now.all_day) } 
    #scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } 
    #scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
    #scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
  #END
  
  #7日分の投稿数
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) }
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) }
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) }
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) }
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) }
  #END
  
    #ソート機能
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :star_count, -> {order(star: :desc)}
  #end
  
  #タグ機能(親子関係)
  has_many :post_book_tags, dependent: :destroy
  has_many :book_tags, through: :post_book_tags
  
  def save_workout_tags(tags)
    current_tags = self.book_tags.pluck(:name) unless self.book_tags.nil?
    
    old_tags = current_tags - tags
    
    new_tags = tags - current_tags
    
    old_tags.each do |old_name|
      self.book_tags.delete BookTag.find_by(name:old_name)
    end
    
    new_tags.each do |new_name|
      book_tag = BookTag.find_or_create_by(name:new_name)
      self.book_tags << book_tag
    end
  end
  #end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
