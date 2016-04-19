class Module
  def create_finder_methods(*attributes)
    # Your code goes here!
    # Hint: Remember attr_reader and class_eval
    attributes.each do |attribute|
      attr = attribute.to_s
      self.class_eval("
        def self.find_by_#{attr}(target_value)
          self.all.each do |product|
            if product.#{attr} == target_value
              return product
            end
          end
        end
      ")
    end
  end
end