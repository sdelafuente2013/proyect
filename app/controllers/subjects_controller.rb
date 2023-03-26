class SubjectsController < ApplicationController
  before_action :set_subject_class

  def index
    data = load_subjects
    response_with_objects(data, data.count)
  end

  private

  def load_subjects
    @subject_class.search(search_params)
  end

  def default_search_param_keys
    super()+[:subid, :userid]
  end

  def set_subject_class
    @subject_class = Objects.tolgeo_model_class(params['tolgeo'], 'subject')
  end
end

