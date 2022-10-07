module Api
  module V1
    class ChatController < ApplicationController

      # for create new chat
      def create
        # to get id from application token
        @application = Application.select('id','token').where('token = ?',[params[:application_token]]).first!

        # to get last number value from application chats to increment it
        last_chat = Chat.select('number').where('application_id = ?',[@application.id]).last
        if last_chat
          number = last_chat.number +=1;
        else
          number = 1
        end

        # create new chat
        @chat = Chat.new(
          :number => number,
          :application_id => @application.id
        )

        if @chat.save
          # to increment chats count of application
          @application.update_attribute(:chats_count, number)

          # return success request with data name & token only
          render json_response_success 'Chat Created', { number:@chat.number, application_token:@application.token }, 201
        else
          render json_response_error 'Sorry Chat not created', @application.errors, :unprocessable_entity
        end

      end

      # for get all application chats from token
      def messages
        # to get last number value from application chats to increment it
        @messages = Application
                      .joins(:chats => :messages)
                      .where('applications.token = ? AND chats.number = ?',params[:token] ,params[:number])
                      .select('messages.number','messages.body')
        render json_response_success 'Messages Data', @messages
      end

      # to handel & catch errors of controller
      rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
      def record_not_found(exception)
        render json_response_error 'Sorry Chat not Founded', {  }, 404
      end
    end
  end
end