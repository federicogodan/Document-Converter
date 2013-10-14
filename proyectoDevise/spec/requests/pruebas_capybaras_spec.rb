require 'spec_helper'

describe "PruebasCapybaras" do
  include Capybara::DSL
  #  Capybara.using_wait_time(10) {click_link 'Register'}

  describe "Pruebas 1 Registro" do
    it "Prueba A Registro ok", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@mundo.com'
      fill_in 'Nick name', :with => 'chechab'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot.png')
      expect(page).to have_content('Welcome! You have signed up successfully')
    end
    it "Prueba B Registro nick <6", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche.com'
      fill_in 'Nick name', :with => 'che'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot.png')
      expect(page).to have_content('Your nickname must be at least 6 characters long')
    end

    it "Prueba C Registro fecha invalida", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche.com'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17061989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot.png')
      expect(page).to have_content('Your birth date must be in the format of DD-MM-YYYY')
    end

    it "Prueba D Registro fecha posterior", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche.com'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/2050'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot4.png')
      expect(page).to have_content('Your birth date must be after now')
    end

    it "Prueba E Registro email sin @", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'holachecheche.com'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot10.png')
      expect(page).to have_content('Your email address must be in the format of name@domain.com')
    end

    it "Prueba F Registro email invalido final", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot10.png')
      expect(page).to have_content('Your email address must be in the format of name@domain.com')
    end
    it "Prueba G Registro password no supera 8", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche.com'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepe'
      fill_in 'Repeat Password', :with => 'pepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot10.png')
      expect(page).to have_content('Your password must be at least 8 characters long')
    end

    it "Prueba H Registro passwords no coinciden", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@checheche.com'
      fill_in 'Nick name', :with => 'checheche'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepeno'
      find('#btnRegister').click
      page.save_screenshot('screenshot10.png')
      expect(page).to have_content("Passwords doesn't match, please try again")
    end

    it "Prueba I Registro campos vacios", :js => true do
      visit '/'
      click_on 'Register'
      find('#btnRegister').click
      page.save_screenshot('screenshotzz.png')
      expect(page).to have_content('We need your birth date to create your account')
      expect(page).to have_content('We need a nickname to create your account')
      expect(page).to have_content('We need your email address to create your account')
      expect(page).to have_content('Please enter a password to create your account')
    end

    it "Prueba J Registro cancelacion", :js => true do
      visit '/'
      click_on 'Register'
      find('#new_user').find('Close').click
      page.save_screenshot('screenshotzz.png')
      expect(page).to have_content('Enter email or nick')
    end

    it "Prueba K Registro usuarioYaExiste nick", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@otroemail.com'
      fill_in 'Nick name', :with => 'chechab'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot.png')
      expect(page).to have_content('Error: nick or email already exists.')
    end

    it "Prueba L Registro usuarioYaExiste email", :js => true do
      visit '/'
      click_on 'Register'
      fill_in 'Email', :with => 'hola@mundo.com'
      fill_in 'Nick name', :with => 'chechabotra'
      fill_in 'First name', :with => 'holita'
      fill_in 'Last name', :with => 'mundito'
      fill_in 'Birth Date', :with => '17/06/1989'
      find('#password').click
      find('#password').set 'pepepepe'
      fill_in 'Repeat Password', :with => 'pepepepe'
      find('#btnRegister').click
      page.save_screenshot('screenshot.png')
      expect(page).to have_content('Error: nick or email already exists.')
    end
end
 describe "Pruebas 2 Login" do
    it "Prueba M Sign In exitoso", :js => true do

      visit '/'
      fill_in 'Enter email or nick', with: 'chechab'
      fill_in 'Password', with: 'pepepepe'
      click_on 'Sign in'
      expect(page).to have_content('Signed in successfully.')
    end
    it "Prueba N Sign In no existe nick", :js => true do

      visit '/'
      fill_in 'Enter email or nick', with: 'chechanoexiste'
      fill_in 'Password', with: 'pepepepe'
      click_on 'Sign in'
      expect(page).to have_content('Wrong user or password, try again')
    end
    it "Prueba O Sign In campos vacios", :js => true do

      visit '/'
      #fill_in 'Enter email or nick', with: 'chechanoexiste'
      #fill_in 'Password', with: 'pepepepe'
      click_on 'Sign in'
      expect(page).to have_content('You must enter your email or your nickname to continue')
      expect(page).to have_content('You must enter your password to continue')
    end

    it "Prueba P Sign In Y Sign out", :js => true do

      visit '/'
      fill_in 'Enter email or nick', with: 'chechab'
      fill_in 'Password', with: 'pepepepe'
      click_on 'Sign in'
      click_on 'My Account'
      click_on 'sign out'
      expect(page).to have_content('Enter email or nick')
    end

  end
end
