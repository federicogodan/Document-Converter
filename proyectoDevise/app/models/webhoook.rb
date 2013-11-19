class Webhoook < ActiveRecord::Base
  attr_accessible :deleted, :url, :user_id
  
  has_many :whsents
  
  def throwebhook( urldoc )
    if not self.deleted
      code, message, body = Webhook.post(self.url, :action => 'ConvertedDocument', :data => urldoc)
      
      if code == '200'
        puts "Success: #{body}"
      else
        puts "Error (#{code}): {message}\n#{body}"
      end
    end  
  end
  
end
