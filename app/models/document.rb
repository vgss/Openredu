# -*- encoding : utf-8 -*-
class Document < ActiveRecord::Base
  CONTENT_TYPES = Redu::Application.config.mimetypes['documents'] +
    Redu::Application.config.mimetypes['image']

  has_attached_file :attachment, Redu::Application.config.paperclip_documents
  validates_attachment_content_type :attachment, :content_type => CONTENT_TYPES
  validates_attachment_presence :attachment

  has_one :lecture, :as => :lectureable
  
end
