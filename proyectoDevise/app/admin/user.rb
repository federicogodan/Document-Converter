ActiveAdmin.register User do
  config.sort_order = "nick"
  
  index do
    column :nick
    #column :name
    #column :surname
    column :email
    column "Converted Documents", :cant_converted_document, :sortable => false
    column "Bandwidth/ B/s", :bandwidth_in_bytes_per_sec
    #column "Conversions /%", :percentage_of_converted_document, :sortable => false
    column "Used storage/Bytes", :used_storage, :sortable => false
    column "Storage assigned/Bytes",:total_storage_assigned, :sortable => false
    column "Average time to convert/min", :average_time_to_convert, :sortable => false
    column "Expiration documents/sec",:documents_time_for_expiration, :sortable => false
    default_actions
  end
  
  filter :nick
  filter :name
  filter :surname
  filter :email
  
  
  form do |f|
    f.inputs "User Details" do
      f.input :max_document_size
      f.input :limit_of_conversions
      f.input :total_storage_assigned
      f.input :documents_time_for_expiration
    end
    f.buttons
  end
end