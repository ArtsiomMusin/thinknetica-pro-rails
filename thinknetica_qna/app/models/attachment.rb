class Attachment < ApplicationRecord
  # hmm... it doesn't work w/o "optional: true"
  belongs_to :attachable, polymorphic: true, optional: true

  validates :file, presence: true
  mount_uploader :file, FileUploader
end
