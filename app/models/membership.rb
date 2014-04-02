class Membership < ActiveRecord::Base
	ROLES = %w[admin moderator author member invited banned]
  belongs_to :user
  belongs_to :movement
end
