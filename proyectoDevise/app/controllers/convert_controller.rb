class ConvertController < ApplicationController
  
  #before_filter :authenticate_user!
  
  def upload
  end
  
  def create
  end 
  
  def get_formats
    ext = params[:extension]
    reg_filename = Format.find_by_name(ext)
    formats = []
    reg_filename.destinies.each do |f|
      formats.push(f.name)
    end
    render :json => formats
  end

end
