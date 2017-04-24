class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user= user

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
    can :create, [Question, Answer, Comment, Subscribe]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Subscribe], user_id: user.id

    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end

    can :select_best_answer, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :me, User, id: user.id
    can :index, User, id: user.id

  end

  def admin_ability
    can :manage, :all
  end
end
