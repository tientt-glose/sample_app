class Micropost < ApplicationRecord
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.maximum_post_length}
  validate :picture_size

  scope :created_at_desc, ->{order created_at: :desc}

  scope(:status_feed, lambda do |user|
    Micropost.where("user_id IN (:id)
      OR user_id = :user_id", id: user.following_ids,
      user_id: user.id)
  end)

  mount_uploader :picture, PictureUploader

  private

  def picture_size
    settings_size = Settings.standard_memory.megabytes
    errors.add :picture, t(".picture_size") if picture.size > settings_size
  end
end
