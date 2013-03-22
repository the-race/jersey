class Padrino::Helpers::FormBuilder::BootstrapFormBuilder < Padrino::Helpers::FormBuilder::AbstractFormBuilder
  # Here we have access to a number of useful variables
  #
  # ** template  (use this to invoke any helpers)(ex. template.hidden_field_tag(...))
  # ** object    (the record for this form) (ex. object.valid?)
  # ** object_name (object's underscored type) (ex. object_name => 'admin_user')
  #
  # We also have access to self.field_types => [:text_field, :text_area, ...]
  # In addition, we have access to all the existing field tag
  # helpers (text_field, hidden_field, file_field, ...)
  def initialize(template, object, options={})
    super(template, object, options)

    [:email_field, :text_field, :password_field].each do |meth|
      define_singleton_method(meth) do |field, opts={}|
        html = super(field, opts)
        wrap_field(field, html)
      end
    end
  end

  #def text_field(field, options={})
    #html = super(field, options)
    #wrap_field(field, html)
  #end

  #def email_field(field, options={})
    #html = super(field, options)
    #wrap_field(field, html)
  #end

  def wrap_field(field, html)
    output = control_group_begin(field)
    output << html
    output << control_group_end(field)
    output
  end

  def control_group_begin(field)
    field_id = field_id(field)
    output   = template.tag(:div, :class => "control-group #{has_error(field)}")
    output << template.label_tag(field_id, :caption => "#{field_human_name(field)}: ", :class => 'control-label')
    output << template.tag(:div, :class => 'controls')
    output
  end

  def control_group_end(field)
    output = template.error_message_on(object, field, :class => 'help-inline')
    output << '</div></div>'
    output
  end

  def has_error(field)
    message = template.error_message_on(object, field, {})

    if message != ''
      'error'
    else
      ''
    end
  end

end
