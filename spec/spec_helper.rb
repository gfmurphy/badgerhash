require "badgerhash"

def reset_class_variables(cl)
  cl.class_variables.each do |var|
    cl.class_variable_set var, nil
  end
end
