class User < ActiveRecord::Base
  attr_accessor :remember_token
  attr_accessor :activation_token
  attr_accessor :reset_token

  has_many :orders
  has_many :order_items, through: :orders
  has_many :products, through: :order_items
  belongs_to :team

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  before_save { self.email.downcase! }
  before_create :create_activation_digest

  has_secure_password

  def User.digest(password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(password, cost: cost)
  end

  def User.all_that_paid_for_main
    User.joins(:orders, :products).where(
                                      "orders.payment_confirmed": true,
                                      "products.name": "main").distinct
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(self.remember_token)
  end

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    self.remember_digest = nil
  end

  def is_sff_member?
    self.sff_validated?
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(self.activation_token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute :reset_digest, User.digest(reset_token)
  end
end
