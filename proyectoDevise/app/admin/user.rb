ActiveAdmin.register User do
  config.per_page = 20
  config.sort_order = "nick"
  
  index do
    column :nick
    #column :name
    #column :surname
    column :email
    column "Porcentage of conv document",:percentage_of_converted_document
    column "Used storage/Bytes", :used_storage
    column "Average time convert/min", :average_time_to_convert
    default_actions
  end
  
  filter :nick
  filter :name
  filter :surname
  filter :email
  
  
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :nick
      f.input :name
      #f.input :birth_date
      f.input :surname
      f.input :password
    end
    f.buttons
  end
end