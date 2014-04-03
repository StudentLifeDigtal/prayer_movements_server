module API
  module V1
    class Movements < Grape::API
      include API::V1::Defaults

      resource :movements do
        desc "Get movements", {
          :entity => API::V1::Entities::Movement,
          :notes => <<-NOTE
            Get a paginated list of movements available to the current user

            Pagination
            ----------

            Pagination info can be found in the response headers in the following format

            * **X-Per-Page** (integer) Number of movements per page
            * **X-Total** (integer) Total Number of movements available
            * **X-Total-Pages** (integer) Total Number of pages
            * **X-Page** (integer) Current pages

          NOTE
        }

        paginate :per_page => 10
        params do
          optional :type, type: Symbol, values: [:minimal, :full, :extended], default: :minimal, desc: "*minimal*, full, or extended"
        end
        get do
          present paginate( Movement.where("privacy = 'open' or id IN (?)", current_user.memberships.where("role != 'banned'").pluck(:movement_id) ) ), with: API::V1::Entities::Movement, user: current_user, type: params[:type]
        end

        desc "Get a movement"
        params do
          requires :id, type: Integer, desc: "Movement ID"
          optional :type, type: Symbol, values: [:minimal, :full, :extended], default: :minimal, desc: "*minimal*, full, or extended"
        end
        route_param :id do
          get '/', :http_codes => [
            [400, "Invalid parameter entry"],
            [404, "ID Not found"]
          ] do
            movement = Movement.find(params[:id])
            if movement.privacy == "open" or current_user.memberships.exists?(["memberships.role != 'banned' and memberships.movement_id = ?", params[:id]])
              present movement, with: API::V1::Entities::Movement, user: current_user, type: params[:type]
            else
              status 404
              {error: "Couldn't find Movement with id=#{params[:id]}"}
            end
          end
        end
        desc "Delete a movement"
        params do
          requires :id, type: String, desc: "Status ID."
        end
        delete ':id' do
          current_user.movement.find(params[:id]).destroy
        end

      end
    end
  end
end