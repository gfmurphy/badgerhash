require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "badgerhash"

Dir["./spec/support/**/*.rb"].each {|f| require f}

def reset_instance_variables(cl)
  cl.instance_variables.each do |var|
    cl.instance_variable_set var, nil
  end
end
