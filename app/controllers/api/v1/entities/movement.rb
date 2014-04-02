module API
  module V1
    module Entities
      class Movement < Grape::Entity
        expose :id, documentation: { required: true, type: "integer", desc: "Unique identifier" }
        expose :name, documentation: { required: true, type: "string", desc: "Name of movement" }
        expose :short_description, documentation: { required: true, type: "integer", desc: "Brief (150 Char Max) description" }
        expose :followers, documentation: { required: true, type: "integer", desc: "Number of people following" } do |movement, options|
          movement.memberships.count
        end
        expose :long_description, if: { type: :full }
        expose :website, if: { type: :full }
        expose :founded, if: { type: :extended }
        expose :founder, if: { type: :extended }
        expose :mission, if: { type: :extended }
        expose :phone, if: { type: :extended }
        expose :email, if: { type: :extended }
        expose :role, documentation: { required: true, type: "string", desc: "One of admin, moderator, author, member, invited, banned" } do |movement, options|
          role = Membership.where(:user_id => options[:user].id, :movement_id => movement.id).first.try(:role)
          if role.nil? then "none" else role end
        end
      end
    end
  end
end