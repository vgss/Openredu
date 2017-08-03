# -*- encoding : utf-8 -*-
module Api
  module TagRepresenter
    include ROAR::JSON
    include ROAR::Feature::Hypermedia

    property :name
  end
end
