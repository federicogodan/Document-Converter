class ApplicationController < ActionController::Base
  protect_from_forgery :excecpt => :create
end
