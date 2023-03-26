class Hash
  def deep_transform_values_with(&block)
    transform_values do |v|
      next(nil) if v.nil?
      next(v.deep_transform_values_with(&block)) if v.respond_to?(:deep_transform_values_with)
      block.call(v)
    end
  end
end


class Array
  def deep_transform_values_with(&block)
    map do |v|
      next(nil) if v.nil?
      next(v.deep_transform_values_with(&block)) if v.respond_to?(:deep_transform_values_with)
      block.call(v)
    end
  end
end
