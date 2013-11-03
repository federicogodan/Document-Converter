class ConvertController < ApplicationController
  
  #before_filter :authenticate_user!
  
  def upload
  end
  
  def create

   #path = params[:post][:uploaded_file].path
   #filename = params[:post][:uploaded_file].original_filename
   #file_divided = filename.split('.')
   #ext = file_divided[file_divided.length-1]
    
   #reg_filename = Format.find_by_name(ext)
   #formatos = reg_filename.destinies
   #imprimir = 'Formatos a los que se puede convertir el archivo: '
   #formatos.each do |formato|
   #   imprimir = imprimir + '  ' + formato.name
   #end
   #render text:imprimir  
  end 
  
  def get_formats
    if params[:extension] != nil
      ext = params[:extension]
      #ext = File.extname(params[:uploaded_file])
    else
      filename = params[:uploaded_file]
      file_divided = filename.split('.')
      ext = file_divided[file_divided.length-1]
    end
    reg_filename = Format.find_by_name(ext) 
    formatos = reg_filename.destinies
    render :json => formatos
  end
  
  #def formats
  #  filename = params[:uploaded_file]
  #  file_divided = filename.split('.')
  #  ext = file_divided[file_divided.length-1]
    
  #  redirect_to "/convert/get_formats?extension="+ext
  #end
   
end
