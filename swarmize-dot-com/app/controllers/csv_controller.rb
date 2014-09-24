class CsvController < ApplicationController
  before_filter :scope_to_swarm
  before_filter :check_for_user

  def show
    results = @swarm.search.entirety
    #formatted_results = SwarmResultsFormatter.new(@swarm,results)
    #send_data formatted_results.to_csv, 
              #filename: "#{@swarm.token}.csv"
    render_csv(results)
  end

  private

  def render_csv(results)
    set_file_headers
    set_streaming_headers

    response.status = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines(results)
  end

  def set_file_headers
    file_name = "#{@swarm.token}.csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(results)
    tool = SwarmCSVTool.new(@swarm)

    Enumerator.new do |y|
      y << tool.headers.to_s
      results.each do |result|
        y << tool.result_to_row(result).to_s
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
