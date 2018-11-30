# -*- encoding : utf-8 -*-
class MyfileService < StoredContentService
  def initialize(options={})
    super options.merge(:model_class => Myfile)
  end

  # Sobrescreve create por causa de autorização específica.
  def create(&block)
    super
    model
  end
end
