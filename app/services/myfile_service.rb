# -*- encoding : utf-8 -*-
class MyfileService < StoredContentService
  def initialize(options={})
    super options.merge(:model_class => Myfile)
  end
end
