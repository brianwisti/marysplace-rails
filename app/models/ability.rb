class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.role? :front_desk
      can :show, Client
      can :create, Checkin
      can :show, Checkin
    end

    if user.role? :staff
      can :manage, Client
      can :manage, User
      can :show, PointsEntryType
      can :manage, PointsEntry
      can :manage, Checkin
      can :manage, ClientFlag
      can [ :show, :create ], ClientNote
      can [ :edit, :delete ], ClientNote, user_id: user.id
      can :show, Message
      can :manage, StoreCart
      can :show, Location
    end

    if user.role? :admin
      can :manage, :all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
