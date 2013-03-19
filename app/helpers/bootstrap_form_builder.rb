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

  def control_group_for(field, &block)
    field_id = field_id(field)
    group    = template.tag(:div, :class => 'control-group')
    group << template.label_tag(field_id, :caption => "#{field_human_name(field)}: ", :class => 'control-label')
    group << template.tag(:div, :class => 'controls')
    group << capture_html(self, &block)
    group << template.error_message_on(field_id, :class => 'help-inline')
    group << '</div></div>'
    group
  end
end