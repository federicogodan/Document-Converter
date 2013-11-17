class ConvertController < ApplicationController
  
  #before_filter :authenticate_user!
  
  def get_formats
    ext = params[:extension]
    reg_filename = Format.find_by_name(ext)
    formats = []
    reg_filename.destinies.each do |f|
      formats.push(f.name)
    end
    render :json => formats
  end

  def get_status
    id = params[:id]
    doc = ConvertedDocument.find(id)

    render :json => { status: doc.current_status.capitalize, url: doc.download_link }
  end

end
