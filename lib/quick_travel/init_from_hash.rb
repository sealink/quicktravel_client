module QuickTravel
  module InitFromHash
    def initialize(hash = {})
      return nil if hash.blank?

      hash.each do |attr, val|
        # set datamember of the object using hash key and value
        if respond_to?("#{attr}=")
          send("#{attr}=", val)
        else
          instance_variable_set("@#{attr}".to_sym, val)
        end
      end
    end
  end
end
