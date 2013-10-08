ActiveAdmin.register User do
  index do
    column :email
    column :password
  end
  
  form do |f| 
    f.inputs "User Details" do
      f.input :email
      f.input :nick
      f.input :password  
      f.input :password_confirmation    
    end
    f.buttons
  end
end
