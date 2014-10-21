class DocumentationController < ApplicationController
  def show
    # find file
    filename = File.join(Rails.root, 'public', 'documentation', "#{params[:id]}.md")
    if File.exist?(filename)
      @body =  Kramdown::Document.new(File.read(filename)).to_html
    end
  end
end
