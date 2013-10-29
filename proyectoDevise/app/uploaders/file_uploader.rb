# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  after :store, :convert

  def convert(file)
    require 'socket'
    configuration = eval(File.open('controller.properties') {|f| f.read })
    ip_redirect = configuration[:ip_redirect]
    format_dest = model.converted_document.format.name
    puts '#'*50
    puts format_dest
    puts '#'*50
    if (format_dest=='html') && (format_origin=='odp' || format_origin=='ppt')
      redirect_port = configuration[:port_unoconv]
    puts "getting server socket"
    else
      redirect_port = configuration[:port_libreoffice]
    end
    puts '#'*50
    puts ip_redirect
    puts redirect_port
    puts '#'*50
    redirect_socket = TCPSocket.new(ip_redirect, redirect_port)
    redirect_socket.puts "16000"
    server_ip = redirect_socket.gets.delete("\n")
    server_port = redirect_socket.gets.delete("\n").to_i
    
    clientSession = TCPSocket.new( server_ip , server_port)
    puts "sending ACK"
    redirect_socket.puts "ACK" 
    clientSession.puts '{"format":"' + format + '","name":"' + file_name + '",URL":' +
    file_path + '",id":' + file.id + '"}' 
    puts "waiting response"
    serverMessage = clientSession.gets
    puts "Recieved: " 
    puts serverMessage
    clientSession.close
end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
