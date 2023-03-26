class DocumentTypesController < ApplicationController
  before_action :set_document_type_class

  def index
    data = load_document_types
    response_with_objects(data, data.count)
  end

  private

  def load_document_types
    @document_type_class.all
  end

  def set_document_type_class
    @document_type_class= Objects.tolgeo_model_class(params['tolgeo'], 'document_type')
  end
end
