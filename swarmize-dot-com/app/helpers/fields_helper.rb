module FieldsHelper
  def validation_for_field_and_description(field, description)
    validations = []

    if description.validation && !description.validation.strip.blank?
      validations << description.validation
    end
    validations << 'required' if field.compulsory

    validations.join(",")
  end

end
