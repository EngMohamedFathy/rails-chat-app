module Api
  module V1
    class ApplicationController < ::ApplicationController

      # for reading application details by token
      def show
        # try find application by token or throw not found error
        @application = Application.select('token','name','chats_count').where('token = ?',[params[:token]]).first!
        render json_response_success 'Application Data', @application.as_json(:except => [:id])
      end

      # for create new application
      def create
        @application = Application.new(post_params)

        # for creating application token Base-64 (url-safe) encoded bytes, 22 characters long 6-byte or 128-bit token is nonunique is so vanishingly small that it is virtually zero
        @application.token = SecureRandom.urlsafe_base64(16)

        if @application.save
          # return success request with data name & token only
          render json_response_success 'Application Created', { name:@application.name, token:@application.token } ,201
        else
          render json_response_error 'Sorry Application not created', @application.errors, :unprocessable_entity
        end
      end

      # for update application by using token
      def update
        @application = Application.where('token = ?',[params[:token]]).first!

        # to prevent race condition
        update_status = false
        Application.transaction do
          @application.lock!
          @application.name = post_params[:name]
          update_status = @application.save!
        end

        if update_status
          render json_response_success 'Application Updated', { name: @application.name, token: @application.token }
        else
          render json_response_error 'Sorry Application not Updated', @application.errors, :unprocessable_entity
        end
      end

      # for get all application chats from token
      def chats
        # try find application by token or throw not found error
        @chats = Application.where('token = ?',[params[:token]]).first!.chats
        render json_response_success 'Chats Data', @chats.as_json(:only=>[:number,:messages_count])
      end

      private
      def post_params
        params.permit(:name)
      end

      # to handel & catch errors of controller
      rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
      def record_not_found(exception)
        render json_response_error 'Sorry Application not Founded', {  }, 404
      end

    end
  end
end