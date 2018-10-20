class Picture < ApplicationRecord
  belongs_to :user

  mount_uploader :image, ImageUploader

  validates :title, :image, presence: true
end
