ActiveAdmin.register Document do
  config.sort_order = "user_id"
  
  index do
    column :user_id
    column :name
    column :file
    column :size
    column :format
    column "conversion time/min", :time_of_conversion, :sortable => false
    default_actions
  end
  
  filter :user_id
  filter :name
  filter :format
  filter :expired
  
  form do |f|
    f.inputs "Document Details" do
      f.input :user
      f.input :format
      f.input :name
      f.input :file
    end
    f.buttons
  end
end
  