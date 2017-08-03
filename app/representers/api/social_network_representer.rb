# -*- encoding : utf-8 -*-
module Api
  module SocialNetworkRepresenter
    include ROAR::JSON

    property :name
    property :url, :from => :profile
  end
end
