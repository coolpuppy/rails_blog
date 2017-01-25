class Blog < ApplicationRecord
  belongs_to :user#, inverse_of: :blogs

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: 500}
  validates :title,   presence: true

  def self.search(pattern)
    Blog.where("title like ?", "%#{pattern}%")
    Blog.where("content like ?", "%#{pattern}%")
  end
end
