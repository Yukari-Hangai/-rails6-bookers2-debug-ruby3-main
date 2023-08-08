class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :message, presence: true, length: { maximum: 140 } #messageで空ではない＆最大140文字以下のバリデーション
end
