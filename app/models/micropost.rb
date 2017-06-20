class Micropost < ApplicationRecord
  belongs_to :user
  scope :feed_sort, -> {order created_at: :desc}
  scope :load_feed, ->id{where "user_id = ?", id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_content_size}
  validates :picture_size

  private

  def picture_size
    if picture.size > Settings.micropost.max_picture_size.megabytes
      errors.add :picture, t(".max_picture_size")
    end
  end
end
