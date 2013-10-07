require 'spec_helper'

describe "PruebasCapybaras" do
  include Capybara::DSL
  describe "Sign In exito" do
    it "Sign In exitoso", :js => true do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #visit 'localhost:3000'
      visit '/'
      #find('Create an account').click
      click_on 'Create an account'
      #page.has_content? 'Create an account'
      #get pruebas_capybaras_path
      #response.status.should be(200)
    end
  end
end
