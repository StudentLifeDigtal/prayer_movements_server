# app/controllers/api/v1/defaults.rb
module API
  module V1
    module Defaults
      # if you're using Grape outside of Rails, you'll have to use Module#included hook
      extend ActiveSupport::Concern

      included do
        include API::Concerns::APIGuard
        include Grape::Kaminari
        guard_all!

        # common Grape settings
        version 'v1'
        format :json

        # global handler for simple not found case
        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        # global handler for incorrect permissions
        rescue_from CanCan::AccessDenied do |e|
          error_response(message: e.message, status: 403)
        end

        # global handler for invalid params
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error_response(message: e.message, status: 400)
        end

        # global exception handler, used for error notifications
        rescue_from :all do |e|
          if Rails.env.development? || Rails.env.test?
            raise e
        else
            Airbrake.notify(e)

            error_response(message: "Internal server error", status: 500)
          end
        end

        helpers do
          def permitted_params
            @permitted_params ||= declared(params, include_missing: false)
          end

          def authorize!(*args)
            ::Ability.new(current_user).authorize!(*args)
           end
        end
      end
    end
  end
end