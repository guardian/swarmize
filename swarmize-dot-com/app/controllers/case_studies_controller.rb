class CaseStudiesController < ApplicationController
  def show
    # find file
    filename = File.join(Rails.root, 'public', 'case_studies', "#{params[:id]}.md")
    if File.exist?(filename)
      @body =  Kramdown::Document.new(File.read(filename)).to_html
    end
  end
end
