# -*- encoding : utf-8 -*-
module Api
  module ClientApplicationRepresenter
    include ROAR::JSON
    include ROAR::Feature::Hypermedia

    property :id
    property :name
    property :url
    property :support_url

  end
end
