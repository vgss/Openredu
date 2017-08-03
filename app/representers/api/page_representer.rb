# -*- encoding : utf-8 -*-
module Api
  module PageRepresenter
    include ROAR::JSON
    include ROAR::Feature::Hypermedia
    include LectureRepresenter

    property :content
    property :raw
    property :mimetype

    def mimetype
      'text/html'
    end

    def content
      self.lectureable.body
    end

    def raw
      PageSanitizer.new(content).sanitize
    end
  end
end
