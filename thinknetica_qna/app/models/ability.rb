class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :build_by_email, User
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscriber]
    can [:update, :destroy], [Question, Answer] do |subject|
      user.author_of?(subject)
    end
    can :destroy, Attachment do |attachment|
      user.author_of?(attachment.attachable)
    end
    can [:vote_yes, :vote_no, :reject_vote], [Question, Answer] do |subject|
      !user.author_of?(subject)
    end
    can :mark_best, Answer do |subject|
      user.author_of?(subject.question)
    end
    can :get_all, :profile
    can :get_me, :profile
  end
end
