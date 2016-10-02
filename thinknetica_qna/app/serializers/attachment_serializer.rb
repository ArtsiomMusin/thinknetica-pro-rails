class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor
  attributes :id, :created_at, :updated_at, :url

  def url
    Rails.application.config.hostname_url + object.file.url
  end
end
