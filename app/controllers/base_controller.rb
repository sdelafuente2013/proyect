class BaseController < ApplicationController
  
  before_action :set_item_class
  before_action :load_item, :only => [:show, :update, :destroy]
  
  def index
    response_with_objects(list_items, count_items)
  end

  def show
    response_with_object(@item)
  end
  
  def create
    response_with_object(create_item, :created)
  end
  
  def update
    update_item
    response_with_object(@item)
  end
  
  def update_all
    response_with_object({"updates_count" => update_all_items})
  end
  
  def delete_all
    response_with_object({"updates_count" => delete_all_items})
  end
  
  def destroy
    destroy_item
    response_with_no_content
  end

  protected

  def list_items
    @item_class.search(search_params)
  end

  def count_items
    @item_class.search_count(search_params)
  end

  def load_item
    @item = @item_class.find(params[:id])
  end
  
  def create_item
    @item_class.create!(item_params)
  end
    
  def update_item
    @item.update!(item_params)
  end
  
  def destroy_item
    @item.destroy!
  end
  
  def update_all_items
    total = 0
    if @item_class.respond_to?("has_searchable_params?") && 
       @item_class.has_searchable_params?(update_all_params[:query]) && 
       update_all_params[:changes].keys.all? {|it| @item_class.new.attributes.keys.include?(it)}
      total = @item_class.search_without_page(update_all_params[:query].to_h).update_all(update_all_params[:changes].to_h)
    end  
    total
  end  
  
  def delete_all_items
    total = 0
    if @item_class.respond_to?("has_searchable_params?") && 
       @item_class.has_searchable_params?(delete_all_params)
      total = @item_class.search_without_page(delete_all_params.to_h).count
      @item_class.search_without_page(delete_all_params.to_h).destroy_all
    end  
    total
  end
  
  def set_item_class
  end

  def item_params
    params.permit(@item_class.new.attributes.keys)
  end
  
  def update_all_params
    params.permit(:query => {}, :changes => {})
  end  
  
  def delete_all_params
    params.permit(:documentids => [])
  end
  
end

