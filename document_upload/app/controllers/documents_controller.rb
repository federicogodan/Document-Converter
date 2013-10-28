class DocumentsController < ApplicationController
  
  def index
     @document = Document.all
  end
  
  def new
    @document = Document.new
  end
  
  def create
    @document = Document.new(:name => params[:document][:name], :file => params[:document][:file])
    @document.save
    #redirect_to documents_path
  end
  
  def show
    @document = Document.find(params[:id])
  end
  def self.remove_old_files
    puts "se imprime cada un minuto*******************************************************"
    puts Date.current
  end
end
