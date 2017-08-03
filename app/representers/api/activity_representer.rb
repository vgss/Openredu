# -*- encoding : utf-8 -*-
module Api
  module ActivityRepresenter
    include ROAR::JSON
    include ROAR::Feature::Hypermedia
    include StatusRepresenter

    include Api::BreadcrumbLinks

    property :answers_count

    def answers_count
      self.answers.count
    end

    link :answers do
      api_status_answers_url(self)
    end
  end
end
