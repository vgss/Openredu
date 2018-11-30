# -*- encoding : utf-8 -*-
class FolderService < StoredContentService
  def initialize(options={})
    super options.merge(:model_class => Folder)
  end

  # Atualiza Folder.
  #
  # Retorna true caso o modelo tenha sido salvo.
  def update(attrs)
    model.update_attributes(attrs)
  end
end
