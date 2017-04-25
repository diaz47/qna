class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :autharizations
  has_many :subscribes, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(object)
    id == object.user_id
  end

  def subscribed?(question)
    @sub = Subscribe.exists?(user_id: id, question_id: question.id)
  end

  def self.find_for_oauth(auth)
    autharization = Autharization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return autharization.user if autharization

    email = auth.info.email
    user = User.where(email: email).first
    if user
      user.autharizations.create(provider: auth.provider, uid: auth.uid)
    else 
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.autharizations.create(provider: auth.provider, uid: auth.uid)
    end 
    user
  end
end
