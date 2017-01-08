class Blog < ApplicationRecord
  belongs_to :user#, inverse_of: :blogs

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: 500}
  validates :title,   presence: true
end
