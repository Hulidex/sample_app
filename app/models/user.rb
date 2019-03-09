
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest

  field :name, type: String
  field :email, type: String
  field :password_digest
  field :remember_digest, type: String
  field :admin, type: Boolean, default: -> {false}
  field :activation_digest, type: String
  field :activated, type: Boolean, default: -> {false}
  field :activated_at, type: DateTime
  field :reset_digest, type: String
  field :reset_sent_at, type: DateTime


  has_many :micropost, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                         inverse_of: :follower, dependent:   :destroy
  has_many :pasive_relationships, class_name: "Relationship",
                         inverse_of: :followed, dependent: :destroy

  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/

  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, on: :create


  def follow(user)
    self.active_relationships.create followed_id: user.id
  end

  def unfollow(user)
    rel_id = nil
    success = nil
    
    self.active_relationships.each do |r|
      if r.followed_id == user.id
        rel_id = r.id
        break
      end
    end

    if !rel_id.nil?
      rel = Relationship.find_by id: rel_id
      success = rel.destroy if !!rel
    end

    !!success
  end

  def following? (user)

    self.active_relationships.each do |r|
      if r.followed_id == user.id
       return true
      end
    end
    
    return false
  end

  def followers
    arr = []
    self.pasive_relationships.each {|r| arr << User.find_by(id: r.follower_id)}
    
    arr
  end

  def following
    arr = []
    self.active_relationships.each {|r| arr << User.find_by( id: r.followed_id)}

    arr
  end

  def feed
    Micropost.
      in(:user_id => self.following.map(&:id)).
      union.
      in(:user_id => self.id).
        order_by(created_at: :desc)
  end

  def refresh
    User.find_by id: self.id
  end
  
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

   def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

   # Defines a proto-feed.
  # See "Following users" for the full implementation.
  
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email = email.downcase
    end

    

    
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end


