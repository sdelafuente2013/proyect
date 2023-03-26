class Objects
  def self.tolgeo_model_class(tolgeo, model_name, namespace='')
    key_class = '%s%s%s' % [tolgeo, namespace, model_name]
    @edicion_model_class_cache ||= {}
    model_class = @edicion_model_class_cache[key_class]

    if model_class.nil?
       namespace = '%s::' % namespace.capitalize unless namespace.blank?

       @edicion_model_class_cache[key_class] = model_class = key_class = (
         '%s::%s%s' % [tolgeo.capitalize(), namespace, model_name.split('_').collect {|i| i.capitalize}.join('')]
       ).constantize
    end

    model_class
  end

  def self.field_class(tolgeo, field_type, field_name)
    @edicion_field_class_cache ||= {}
    key_class = '%s%s%s' % [tolgeo, field_type, field_name]
    name_class = @edicion_field_class_cache[key_class]

    if name_class.nil?
      @edicion_field_class_cache[key_class] =  name_class = (
        '%s::Edicion::%s%sField' % [tolgeo.capitalize, field_name.capitalize]
      ).constantize
    end

    name_class
  end

  def self.search_command_class(type)
    type = type.to_s.capitalize
    @search_command_class_cache ||= {}
    search_class = @search_command_class_cache[type]

    if search_class.nil?
      @search_command_class_cache[type] = search_class = (
        'Search::%sCommand' % type
      ).constantize
    end

    search_class
  end
end
