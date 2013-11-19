class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at
      
      #map
      # t.datetime :registration_date  ##it's mapped to t.created_at
      # t.datetime :last_access        ##it's mapped to t.last_sign_in_at

      t.string :profile_type
      t.string :name
      t.string :nick
      t.string :surname
      t.datetime :birth_date
      
      t.string :api_key
      t.string :secret_key
      
      default_values = obtain_default_values
      t.integer :total_storage_assigned, null: false, default: default_values[:storage].to_i
      t.integer :documents_time_for_expiration,null:false, default: default_values[:documents_time_expiration].to_i
      t.integer :bandwidth_in_bytes_per_sec, null: false, default: 0
      t.integer :max_document_size, null: false, default: default_values[:max_document_size].to_i
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
       
  end
  
  def obtain_default_values
    eval(File.open('default_values.properties') {|f| f.read })
  end
end