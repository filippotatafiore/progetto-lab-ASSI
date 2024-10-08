class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :chats, dependent: :destroy
  has_many :friendships
  has_many :friends, through: :friendships

  before_create :set_default_profile_image, :set_default_pro


  before_save :set_default_nickname

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.name = auth.info.name
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def set_default_profile_image
    self.profile_image ||= 0
  end

  def set_default_nickname
    self.nickname ||= self.name
  end

  def set_default_pro
    self.pro ||= false
  end
end
