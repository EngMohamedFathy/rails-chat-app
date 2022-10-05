module Api
  module V1
    class MessageController < ApplicationController

      # for create new chat
      def create
        # to get chat id
        @chat = Application
                  .joins(:chats)
                  .select('chats.id')
                  .where('token = ? AND number = ?',params[:application_token],params[:chat_number]).first!

        # to get last number value from messages to increment it
        last_message = Message.select('number').where('chat_id = ?',@chat.id).last
        if last_message
          number = last_message.number += 1;
        else
          number = 1
        end

        # create new message
        @message = Message.new(
          :number => number,
          :chat_id => @chat.id,
          :body => params[:body]
        )

        if @message.save
          # return success request with data name & token only
          render json_response_success 'Message Created', { number:@message.number, body:@message.body }
        else
          render json_response_error 'Sorry Message not created', @application.errors, :unprocessable_entity
        end

      end

      # for searching in message body
      def search
        # to get id from application token
        @chat = Application
                  .joins(:chats)
                  .select('chats.id')
                  .where('token = ? AND number = ?',params[:token],params[:number]).first!

        # query for elastic search api
        query = {
          query: {
            bool: {
              must: [
                {
                  match: {
                    body: params[:keyword]
                  }
                },
                {
                  term: {
                    chat_id: @chat.id
                  }
                }
              ]
            }
          },
          _source: [:number, :body]
        }
        # return only number and body of the message
        @search_results = Message.__elasticsearch__.search(query).records.as_json(only: [:number, :body])
        render json_response_success 'Messages Result', @search_results
      end

      # to handel & catch errors of controller
      rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
      def record_not_found(exception)
        render json_response_error 'Sorry Model not Founded', {  }, 404
      end

    end
  end
end
