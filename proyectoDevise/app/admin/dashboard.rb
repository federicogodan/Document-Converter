ActiveAdmin.register_page "Dashboard" do
  
  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    
    columns do
      column do
          panel "Total used storage" do
            total_used_storage
          end
      end
    
      column do
          panel "Average time to convert" do
            total_average_time_to_convert
          end
      end
    end
    
    columns do
      column do
          panel "Converted Document" do
            total_converted_document
          end
      end
      
      column do
        panel "Percentage of converted document" do
          total_percentage_of_converted_document
        end
      end
      
      column do
          panel "Used Bandwidth" do
            total_bandwidth_used
          end
      end
    end
    
    columns do
      column do
        panel "Default values" do
          ul do
            li "Default storage(bytes): " + get_default_storage.to_s
            li "Document max size(bytes): " + get_max_document_size.to_s 
            li "Time for expiration(seconds): " + get_default_documents_time_expiration.to_s
          end
        end
      end
    end
  end

end

  def total_used_storage
    total_storage = 0
    User.all.each do |u|
      total_storage += u.used_storage if u.used_storage
    end
    total_storage
  end
  
  def total_average_time_to_convert
    total_average = 0
    User.all.each do |u|
      total_average += u.average_time_to_convert
    end
    total_average = (total_average/User.count).round(3)
  end
  
  def total_percentage_of_converted_document
    total_porcentage = 0
    User.all.each do |u|
      total_porcentage += u.percentage_of_converted_document
    end
    total_porcentage = total_porcentage/User.count
  end
  
  def total_converted_document
    total_cant = 0
    User.all.each do |u|
      total_cant += u.cant_converted_document
    end
    total_cant
  end
  
def total_bandwidth_used
  total_bandwidth = 0
  User.all.each do |u|
    total_bandwidth += u.bandwidth_in_bytes_per_sec
  end
  total_bandwidth
end

def get_default_storage
  default_values = eval(File.open('default_values.properties') {|f| f.read })
  storage = default_values[:storage]
  storage
end

def get_default_documents_time_expiration
  default_values = eval(File.open('default_values.properties') {|f| f.read })
  time = default_values[:documents_time_expiration]
  time
end

def get_max_document_size
  default_values = eval(File.open('default_values.properties') {|f| f.read })
  max_doc = default_values[:max_document_size]
  max_doc
end

def get_limit_of_conversions
  default_values = eval(File.open('default_values.properties') {|f| f.read })
  limit = default_values[:limit_of_conversions]
  limit
end