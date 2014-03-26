require "badgerhash"

def reset_instance_variables(cl)
  cl.instance_variables.each do |var|
    cl.instance_variable_set var, nil
  end
end
