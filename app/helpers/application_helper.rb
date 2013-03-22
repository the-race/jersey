YellowJersey.helpers do

  def bootstrap_class_for(flash_type)
    case flash_type
    when :success
      'alert-success'
    when :error
      'alert-error'
    when :alert
      'alert-block'
    when :notice
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def error_class_for(form_builder, field)
    object = form_builder.object
    object = object.is_a?(Symbol) ? instance_variable_get("@#{object}") : object
    error  = object.errors[field] rescue nil

    if Array(error).first
      'error'
    else
      ''
    end
  end

end
