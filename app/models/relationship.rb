class Relationship
  include Mongoid::Document
  include Mongoid::Timestamps


  belongs_to :follower, class_name: "User", inverse_of: :active_relationships
  belongs_to :followed, class_name: "User", inverse_of: :pasive_relationships

  index({follower: 1, followed: 1}, {unique: true})

  validates :follower, presence: true
  validates :followed, presence: true

  
end
