require 'spec_helper'

describe "PruebasCapybaras" do
  include Capybara::DSL
  
  describe "Sign In exito" do
    it "Sign In exitoso", :js => true do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/'
      #click_on 'Create an account'
  #    click_link 'Create an account'
      
      
      fill_in 'Enter email or nick', with: 'chechab'
  #   find('#panel-register').trigger('focus')
    
     fill_in 'Password', with: 'holamundo'
     click_button 'Sign in'
  #    click_on 'Sign in'
   #   page.execute_script("$('#panel-register').focus()")
      #within ('form#new_user') {expect(page).to have_content('Surname')}
      expect(page).to have_content('Signed in successfully.')
 #     page.should have_content('Signed in successfully.')
      #find("//input[@id='surname']").set('barreiro')
      #find('#surname').set('barreiro')
    end
  end
end
