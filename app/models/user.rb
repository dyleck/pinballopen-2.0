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

  before_save :email_downcase, :name_capitalize
  before_create :create_activation_digest

  has_secure_password

  def User.digest(password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(password, cost: cost)
  end

  def User.all_that_paid_for_main_and_not_for_team
    payed_for_main = User.joins(:orders, :products).where(
          "orders.payment_confirmed": true,
          "products.name": "main"
    ).distinct
    payed_for_team = User.joins(:orders, :products).where(
                                                      "orders.payment_confirmed": true,
                                                      "products.name": "team"
    ).distinct
    assigned_to_teams = User.where.not(team: nil)
    payed_for_main - payed_for_team - assigned_to_teams
  end

  def User.all_that_ordered_main
    User.joins(:products).where("products.name": "main").distinct.order(:id)
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

  def team_captain?
    User.joins(:orders,:products).where(
                                     "orders.payment_confirmed": true,
                                     "products.name": "team",
                                      "orders.user_id": self.id).count > 0
  end

  def team_with_override
    if team_without_override.nil? and team_captain?
      Team.find_by(captain_id: self.id)
    else
      team_without_override
    end
  end
  alias_method_chain :team, :override

  def main_payed?
    self.orders.joins(:products).where("products.name": "main", "orders.payment_confirmed": true).length > 0
  end

  private
    def email_downcase
      self.email.downcase!
    end

    def name_capitalize
      self.first_name.capitalize!
      self.last_name.capitalize!
    end
end
