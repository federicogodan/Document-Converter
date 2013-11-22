### ## DocConverter

## Summary

This gem provides the functionality of convert files between diferents extensions by using the services of the aplication Document Converter located in the cloud.
It is a Ruby on Rails application which, through the services of LibreOffice and UNO converter allows you to improve your application.
Some of the extensions supported are: TXT, ODS, ODP, PDF, HTML, etc.
For more information about supported formats and its dependencies go to:
LINK

## Install

gem install rest_client
gem install doc_converter

## Requirements

* Ruby 1.9.3 or higher.

## Before using the gem…

Before using the gem for the first time it is necessary to Access to the Document Converter web page (documentconverter-env.elasticbeanstalk.com) and register a new user. After registering, the users dashboard is displayed and you can see My Api Keys link on the left. By clicking on that link you can get your api and secret key, which are required to validate the user in the system and allow him to use the gem´s functionalities.
The gem will be notified once a conversion is finished through a specific webhook the user configured in his dashboard. Afterwards, the system will notify the application through the configured URL (or URL’s) by sending a JSON containing the conversion status and the download link of the converted file.
For see details about Webhooks: 

## Configure

Before starting to use the gem you will need to configure it. To do this you will need the pair of keys mentioned before, which will allow you to configure the gem.
To do this you will have to enter the following ruby code:
DocConverter.configure({:server_address => “<API_addres>”; :api_key => “<your_public_key>”; :secret_key => “<your_secret_key>”})
The actual server address is:  http://documentconverter-env.elasticbeanstalk.com/
Now you can use the convert files using the gem.
Notice that this messages are sent through a JSON format.  
 
## How to use?:

The gem has three functionalities, which are:
1. Get conversion formats for a specific format:
DocConverter.get_formats(“formato”)
2. There are two posible options to convert a file:
2.1. Convert a file to one of the possible destination formats: 
DocConverter.convert_document(“file_path”,”destiny_format”, “FILE”)
Where file_path is the path where the file is located and destiny_format is the format to which the file will be converted.
2.2. Convert a file from an URL:
DocConverter.convert_document(“file_url”,”destiny_format”,”URL”)
Where file_url is the URL where the file is located and destiny_format is the format to which the file will be converted.
3. Get available storage space(for converted files) for a specific user:
DocConverter.get_free_space


## Example

#This examples converts example.txt file to all the possible conversions formats
destinies_formats = DocConverter.get_formats(“txt”)
destinies_formats.each do |f|
	#convert example.txt to one of the possible conversion formats
DocConverter.convert(“/home/example.txt”, f, ”FILE”)
end
#After all conversions are finished, we get the free storage space remaining
remaining_space = DocConverter.get_free_space
puts “Now, your available space is: ” + remaining_space 

Dependencies
We try not to reinvent the wheel, so Document Converter is built with other open source projects:
Tools	Use
Devise	Handles users
Active Admin	Handles administrators
Whenever	Executes functions periodically.
Aws-S3	Allows communication with amazon services.. 
Rest-client	Forms the http messages. 
Capybara	Used to test the interface.
Rspec	Used for unit testing.
JMeter	Used for performance and load testing.

