require 'spec_helper'

describe "PruebasCapybaras" do
  include Capybara::DSL
#  Capybara.using_wait_time(10) {click_link 'Register'}
  
  describe "Sign In exito" do
    it "Sign In exitoso", :js => true do
   #   registroChechab
      u1 = User.new(email:"checha@hola.com", nick:"chechab", password:"holamundo")
      u1.save
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/'
      #click_on 'Create an account'
  #    click_link 'Create an account'
      
    #  click_link 'Register'
   #   within ('#registerModal') do
        
  #        fill_in'Email', with: 'hola@mundo.com'
        
 #     end
 #find('#new_user').trigger('focus')
 
      #find('email').set 'hola@mundo.com'
  #    fill_in 'Email', :with => 'hola@mundo.com'
  #    fill_in 'Nick name', :with => 'hola'
  #    fill_in 'First name', :with => 'holita'
  #    fill_in 'Last name', :with => 'mundito'
  #    fill_in 'Birth Date', :with => '23-11-87'
  #    fill_in 'Password', :with => 'pepepepe'
  #    fill_in 'Repeat Password', :with => 'pepepepe'
  #    click_button 'Register'
   #   expect(page).to have_content('Welcome')
   
   
      fill_in 'Enter email or nick', with: 'chechab'
  #   find('#panel-register').trigger('focus')
    
     fill_in 'Password', with: 'holamundo'
 #    click_button 'Sign in'
      click_on 'Sign in'
   #   page.execute_script("$('#panel-register').focus()")
      #within ('form#new_user') {expect(page).to have_content('Surname')}
      expect(page).to have_content('Signed in successfully.')
 #     page.should have_content('Signed in successfully.')
      
      #find('#surname').set('barreiro')
    end
  end
end
