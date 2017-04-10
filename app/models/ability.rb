class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user= user
    user ||= User.new # guest user

    if user
      user.admin? ? admin_ability : user_ability
    else
      guest_ability
    end

  end

  def guest_ability
    can :read, :all
  end

  def user_ability
    guest_ability
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :select_best_answer, Answer do |answer|
      user.author_of?(answer.question)
    end
  end

  def admin_ability
    can :manage, :all
  end
end
