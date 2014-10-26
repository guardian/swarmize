class UtilsController < ApplicationController
  def name_to_code
    render text: params[:name].strip.parameterize.underscore
  end
end
