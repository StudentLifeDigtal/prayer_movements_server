module API
  module V1
    class Movements < Grape::API
      include API::V1::Defaults

      resource :movements do
        desc 'Get movements',
             entity: API::V1::Entities::Movement,
             notes: <<-NOTE
                Get a paginated list of movements available to the current user

                Pagination
                ----------

                Pagination info can be found in the response headers

                * **X-Per-Page** (integer) Number of movements per page
                * **X-Total** (integer) Total Number of movements available
                * **X-Total-Pages** (integer) Total Number of pages
                * **X-Page** (integer) Current pages

             NOTE

        paginate per_page: 10
        params do
          optional :type,
                   type: Symbol,
                   values: [:minimal, :full, :extended],
                   default: :minimal,
                   desc: '*minimal*, full, or extended'
        end
        get do
          present paginate(Movement.
                           where("privacy = 'open' or id IN (?)",
                                 current_user.
                                 memberships.
                                 where("role != 'banned'").
                                 pluck(:movement_id)
                           )),
                  with: API::V1::Entities::Movement,
                  user: current_user,
                  type: params[:type]
        end

        desc 'create a movement'
        params do
          group :movement do
            requires :name, type: String
            requires :short_description, type: String
            requires :privacy,
                     type: Symbol,
                     values: [:open, :closed, :secret],
                     default: :open,
                     desc: '*open*, closed, or secret'
          end
        end
        post do
          @movement = Movement.create permitted_params
          present @movement,
                  with: API::V1::Entities::Movement
        end

        desc 'Get a movement'
        params do
          requires :id, type: Integer, desc: 'Movement ID'
          optional :type,
                   type: Symbol,
                   values: [:minimal, :full, :extended],
                   default: :minimal,
                   desc: '*minimal*, full, or extended'
        end
        route_param :id do
          get '/', http_codes: [[400, 'Invalid parameter entry'],
                                [404, 'ID Not found']] do
            @movement = Movement.find(params[:id])
            authorize! :get,
                       @movement,
                       message: 'Unable to retrieve this movement'
            present @movement,
                    with: API::V1::Entities::Movement,
                    user: current_user,
                    type: params[:type]
          end
        end

        desc 'Delete a movement'
        params do
          requires :id, type: String, desc: 'Movement ID'
        end
        delete ':id', http_codes: [[403, 'Permission denied'],
                                   [404, 'ID Not found']] do
          @movement = Movement.find(params[:id])
          authorize! :delete,
                     @movement,
                     message: 'Unable to delete this movement'
          @movement.destroy
          present 'success'
        end

      end
    end
  end
end
