class ApplicationActivetypeRecord < ActiveType::Object
  self.abstract_class = true
  
  def self.nested_attributes_params
    self.nested_attributes_options.keys.map do |nested_key|
      { '%s_attributes' % nested_key => {} }
    end
  end

  def self.permit_values
    self.new.attributes.keys.map {|it| self.new[it].is_a?(Array) ? {it =>[]} : self.new[it].is_a?(Hash) ? {it => {}} : it} + self.nested_attributes_params
  end
end
