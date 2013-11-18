class AdmindefaultvaluesController < ApplicationController

  def set_default_values
    default_values = eval(File.open('default_values.properties') {|f| f.read })
    if !params[:storage].nil?
      default_values[:storage] = params[:storage] 
    end
      
    if !params[:documents_time_for_expiration].nil?
      default_values[:documents_time_expiration] = params[:documents_time_for_expiration] 
    end
      
    if !params[:max_document_size].nil?
    default_values[:max_document_size] = params[:max_document_size] 
    end
    
    if !params[:limit_of_conversions].nil?
    default_values[:limit_of_conversions] = params[:limit_of_conversions]
    end
    
    File.open('default_values.properties', 'w') do |f|
      f.puts default_values
    end
    puts "****************************************************************"
    redirect_to "/admin/dashboard"
  end
end
