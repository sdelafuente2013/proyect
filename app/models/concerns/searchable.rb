module Searchable
  extend ActiveSupport::Concern

  included do
    def pretty_detail
      { :id => self.id }
    end

    def self.search(params)
      search_scopes(params).
      sorted_scope(params).
      page(params[:page] ||= 0).
      per(params[:per] )
    end

    def self.search_count(params)
      search_scopes(params).count
    end

    def self.searchable_by(field_name)
      self.class_eval do
        cattr_accessor :searchable_field_name
        scope :by_ids, ->(ids) { (ids.nil? or ids.blank?) ?  all : where(:id => ids) }
        scope :autocomplete, -> (q) {q.blank? ? all : where("LOWER(#{searchable_field_name.to_s}) LIKE ?", "%#{q.downcase}%").order("CHAR_LENGTH(#{searchable_field_name.to_s}) ASC")}
        scope :search_scopes, -> (params) { autocomplete(params[:q]).by_ids(params[:ids]) }
      end
      self.searchable_field_name = field_name
    end
    
    def self.sorted_scope(params) 
      sort_param=params[:sort]
      params[:sort].present? ? order("%s %s" % [params[:sort]=="id" ? "%s.id" % self.table_name : params[:sort], params[:order] || "desc"]) : all
    end  
    
    def self.search_without_page(params)
      search_scopes(params)
    end

    def self.has_searchable_params?(params = {})
      keys_to_update = (params.keys.map(&:to_s) & searchable_params)
      keys_not_blank = params.select do |k, v|
        keys_to_update.include?(k.to_s) && v.is_a?(Array) ? !v.empty? : v.present?
      end

      self.respond_to?(:searchable_params) && !keys_not_blank.empty?
    end

    private

    def self.search_scopes(params)
      by_ids(params[:ids])
    end
  end
end
