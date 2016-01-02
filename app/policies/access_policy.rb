class AccessPolicy
  include AccessGranted::Policy

  def configure
    role :admin, proc { |user| user.present? && user.is_admin == true } do
      can :read, Group
      can :read, User
      can :read, Activity
      can :update, Activity
      can :post, Message
      can :public_profile, User
      can :vote, DropUserVote
      can :vote, ExpandGroupVote
      can :create, Topic
      can :read, AdminDash
    end

    role :member, proc { |user| user.present? } do
      can :read, Group do |group, user|
        group.includes_user?(user)
      end

      can :read, User do |user, current_user|
        user == current_user
      end

      can :read, Activity do |activity, user|
        activity.group_includes_user?(current_user)
      end

      can :update, Activity do |activity, user|
        activity.proposed_by?(user)
      end

      can :public_profile, User do |user, current_user|
        current_user.is_friends_with?(user) || user == current_user
      end

      can :post, Message do |message, user|
        case message.messageable.class.name
        when "Topic", "Activity"
          message.group_includes_user?(user)
        when "User"
          message.messageable_is_friends_with?(user)
        end
      end

      can :vote, DropUserVote do |vote, current_user|
        current_user.can_vote?(vote.user)
      end

      can :vote, ExpandGroupVote do |vote, user|
        vote.group_includes_user?(user)
      end

      can :create, Topic do |topic, user|
        topic.group_includes_user?(user)
      end
    end
  end
end
