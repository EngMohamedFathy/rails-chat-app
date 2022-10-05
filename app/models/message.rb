class Message < ApplicationRecord
  validates :body, :presence => true
  belongs_to :chat

  # for elastic search
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping do
    indexes :body, type: :text
  end
end
