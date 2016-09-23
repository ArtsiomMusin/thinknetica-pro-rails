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
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Vote, Attachment]
    can [:update, :destroy], [Question, Answer], user: user
    can [:vote_yes, :vote_no, :reject_vote], [Question, Answer] do |subject|
      subject.user != user
    end
    can :mark_best, Answer, user: user
  end
end
