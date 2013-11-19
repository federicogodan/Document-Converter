ActiveAdmin.register ConvertedDocument do
  config.sort_order = "document_id"
  actions :all, except: [:edit, :destroy, :new]
  #actions :all, :except => [:new]
  
  index do
    column  "Document",:document_id
    column :download_link
    column :conversion_end_date
    column :status
    
    default_actions
  end
  
  filter :id
  filter :document_id
  filter :conversion_end_date
  filter :status
end
