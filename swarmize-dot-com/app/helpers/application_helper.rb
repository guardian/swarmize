module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end


  # this comes from the old Sinatra app
  def format_timestamp(ts)
    t = Time.at(ts / 1000 / 1000)
    t.strftime("%d %B %Y %H:%M:%S")
  end
end
