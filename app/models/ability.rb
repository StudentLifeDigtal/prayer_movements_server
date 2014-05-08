class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Movement
    can :get, Movement, privacy: 'open'
    can \
      :get,
      Movement,
      memberships: { user_id: user.id,
                     role: %w(moderator author member invited) }
    cannot :get, Movement, memberships: { user_id: user.id, role: 'banned' }
    can :manage, Movement, memberships: { user_id: user.id, role: 'admin' }
  end
end
