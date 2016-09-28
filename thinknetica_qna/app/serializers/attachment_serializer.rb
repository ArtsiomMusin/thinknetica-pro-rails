class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::UrlFor
  attributes :id, :created_at, :updated_at, :url

  def url
    'http://' + Rails.application.config.action_controller.default_url_options[:host] + ':' +
      Rails.application.config.action_controller.default_url_options[:port].to_s +
      object.file.url
  end
end
