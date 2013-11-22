class Webhoook < ActiveRecord::Base
  attr_accessible :url, :user_id, :enabled
  
  has_many :whsents
  
  validates_uniqueness_of :url, :scope => :user_id
  
  def throwebhook( status, urldoc )
    if self.enabled

      code, message, body = Webhook.post(self.url, :notification => status.to_s, :data => urldoc)
      
      if code == '200'
        whs = Whsent.new(:url => self.url, :urldoc => urldoc, :notification => status, :state => 0, :attempts => 1)
        self.whsents.push(whs)
        self.save
      else
        whs = Whsent.new(:url => self.url, :urldoc => urldoc, :state => 1, :attempts => 1)
        self.whsents.push(whs)
        self.save
      end
    end  
  end
  
end
