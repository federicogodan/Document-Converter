require 'spec_helper'

describe Webhook do
  
  it 'user_id uniqueness' do
    w = Webhook.new()
    u = register_user
    #w.user = u # ???? ¿no hay relacion entre webhoow y user?
    w.user_id = u.id
    w.save 
    
    w2 = Webhook.new()
    #w2.user = u 
    w2.user_id = u.id
    w2.valid?.should == false
  end
  
end
