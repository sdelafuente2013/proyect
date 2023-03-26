require 'rake'
Rails.application.load_tasks

class DbController < ApplicationController
  def delete
    Rake::Task['db:clean_db_tests'].execute

    response_with_no_content
  end

  def destroy
    Rake::Task['db:prepare_for_binding_tests'].execute

    response_with_no_content
  end
end
