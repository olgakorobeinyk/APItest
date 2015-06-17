require 'json'

class JsonHelpers

    def to_json(obj)
      obj_hash = {}

      obj.instance_variables.each do
        |var|
        obj_hash[var.to_s.delete("@")] = obj.instance_variable_get(var)
      end

      return obj_hash.to_json
    end


end