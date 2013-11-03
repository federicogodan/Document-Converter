class ConvertController < ApplicationController
  
  #before_filter :authenticate_user!
  
  def upload
  end
  
  def create
  end 
  
  def get_formats
    ext = params[:extension]
    reg_filename = Format.find_by_name(ext) 
    formatos = reg_filename.destinies
    render :json => formatos
  end

end
