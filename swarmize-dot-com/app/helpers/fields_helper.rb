module FieldsHelper
  def validation_for_field_and_description(field, description)
    validations = []

    validations << 'required' if field.compulsory
    validations << description.validation

    validations.join(",")
  end

end
