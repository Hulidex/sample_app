
class Micropost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :user_id, type: Integer

  belongs_to :user
  default_scope -> {order created_at: :desc}

  mount_uploader :picture, PictureUploader
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate  :picture_size

   # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
