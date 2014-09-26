class CsvController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_for_user, :except => %w{public}

  def show
    results = @swarm.search.entirety

    render_csv(results)
  end

  def public
    if @swarm.closed? || @current_user
      results = @swarm.search.entirety

      render_csv(results, true)
    else
      flash[:error] = "You can't download CSV for a Swarm still in progress."
      redirect_to @swarm
    end
  end

  private

  def render_csv(results, is_public=false)
    set_file_headers
    set_streaming_headers(is_public)

    response.status = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines(results, is_public)
  end

  def set_file_headers
    file_name = "#{@swarm.token}.csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers(is_public)
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    #if is_public
      #headers["Cache-Control"] = "max-age=#{1.year.to_i}"
    #end
    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(results, is_public)
    tool = SwarmCSVTool.new(@swarm)

    Enumerator.new do |y|
      y << tool.headers.to_s
      results.each do |result|
        if is_public
          y << tool.result_to_public_row(result).to_s
        else
          y << tool.result_to_row(result).to_s
        end
      end
    end
  end

  def scope_to_swarm
    @swarm = Swarm.find_by(token: params[:swarm_id])
    if @swarm && @swarm.draft?
      check_for_user
    end
  end
end
