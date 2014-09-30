module FieldsHelper
  def validation_for_field_and_description(field, description)
    validations = []

    if description.validation && !description.validation.strip.blank?
      validations << description.validation
    end
    validations << 'required' if field.compulsory

    validations.join(",")
  end

  def parsley_validations_for_field(field)
    validations = {}
    if field.compulsory
      validations['data-parsley-required'] = true
    end

    case field.field_type
    when 'url'
      validations['data-parsley-type'] = 'url'
    when 'number'
      validations['data-parsley-type'] = 'number'
    when 'postcode'
      validations['data-parsley-postcode'] = true
    when 'email'
      validations['data-parsley-type'] = 'email'
    when 'yesno'
      validations['data-parsley-errors-container'] = "#errors_#{field.field_code}"
      validations['data-parsley-error-message'] = "Please choose either yes or no."
      validations['data-parsley-class-handler'] = "#group_#{field.field_code}"
    when 'pick_one'
      validations['data-parsley-errors-container'] = "#errors_#{field.field_code}"
      validations['data-parsley-error-message'] = "Please pick one option from the list."
      validations['data-parsley-class-handler'] = "#group_#{field.field_code}"
    when 'rating'
      validations['data-parsley-errors-container'] = "#errors_#{field.field_code}"
      validations['data-parsley-error-message'] = "Please pick a rating from #{field.minimum} to #{field.maximum}."
      validations['data-parsley-class-handler'] = "#group_#{field.field_code}"
    when 'pick_several'
      validations['data-parsley-errors-container'] = "#errors_#{field.field_code}"
      validations['data-parsley-class-handler'] = "#group_#{field.field_code}"
      if field.minimum
        validations['data-parsley-mincheck'] = field.minimum
      end
      if field.maximum
        validations['data-parsley-maxcheck'] = field.maximum
      end
      if field.minimum && field.maximum
        validations['data-parsley-error-message'] = "Please pick between #{field.minimum} and #{field.maximum} options."
      elsif field.minimum
        validations['data-parsley-error-message'] = "Please pick at least #{pluralize field.minimum, 'option'}."
      elsif field.maximum
        validations['data-parsley-error-message'] = "Please pick no more than #{pluralize field.maximum, 'option'}."
      elsif field.compulsory
        validations['data-parsley-error-message'] = "Please pick at least one option."
      end

    when 'check_box'
      validations['data-parsley-errors-container'] = "#errors_#{field.field_code}"
      validations['data-parsley-error-message'] = "Please check the checkbox."
      validations['data-parsley-class-handler'] = "#group_#{field.field_code}"
    end

    if field.minimum
      if field.field_type == 'pick_several'
      else
        validations['data-parsley-min'] = field.minimum
      end
    end

    if field.maximum
      if field.field_type == 'pick_several'
        validations['data-parsley-maxcheck'] = field.maximum
      else
        validations['data-parsley-max'] = field.maximum
      end
    end

    validations
  end

end
