Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do

      # applications routes
      get 'applications/:token',:controller => :application, :action => :show
      post 'applications',:controller => :application, :action => :create
      put 'applications/:token',:controller => :application, :action => :update
      get 'applications/:token/chats',:controller => :application, :action => :chats

      # chats routes
      post 'chats',:controller => :chat, :action => :create
      get 'applications/:token/chats/:number',:controller => :chat, :action => :messages

      # messages routes
      post 'messages',:controller => :message, :action => :create
      get 'applications/:token/chats/:number/messages/search',:controller => :message, :action => :search

    end
  end
end
