# -*- encoding : utf-8 -*-
module Api
  module ExerciseRepresenter
    include ROAR::JSON
    include ROAR::Feature::Hypermedia
    include LectureRepresenter
  end
end
