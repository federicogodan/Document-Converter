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
      
      #obtaining the destiny format's name
      format_dest = model.converted_document.format.name.downcase
      #obtaining the file's name
      file_name = model.name
     
      #file_url = model.file.url
      #parse url
      
      #Parsing the url to change to a correct url to upload the file in S3  
      url = model.file.url.split('.s3.amazonaws.com')
      file_url = "s3" + url[0].split('https')[1] + url[1]
      puts file_url
     
      #obtaining the origin format's name
      format_origin = model.format.name.downcase
      file_id = model.id.to_s
     
      puts "getting server socket"
      if (format_dest=='html') && (format_origin=='odp' || format_origin=='ppt')
        redirect_port = configuration[:port_unoconv]
      else
        redirect_port = configuration[:port_libreoffice]
      end
      
      ok = false
      while(!ok)
        puts redirect_port
        redirect_socket = TCPSocket.new(ip_redirect, redirect_port)
        size = model.size.to_s 
        puts  size
        redirect_socket.puts size
        server_ip = redirect_socket.gets.delete("\n").to_s
        server_port = redirect_socket.gets.delete("\n").to_i
        puts "server_ip"
        puts server_ip
        puts "server_port"
        puts server_port      
        puts '#-'*25
        puts model.to_json
        begin
          @clientSession = TCPSocket.new(server_ip , server_port)
          ok = true
        rescue(Errno::ECONNREFUSED)
          ok = false
          redirect_socket.puts "error"
        end
        if(ok)
          redirect_socket.puts "ok" 
        end
     end
      msg_to_send = "{\"format\":\"" + format_dest + "\",\"name\":\"" + file_name + "\",\"URL\":\"" + file_url + "\",\"id\":\"" + file_id + "\",\"size\":\""+  size + "\"}" 
      puts msg_to_send 
      @clientSession.puts msg_to_send
      ack = @clientSession.gets
      puts "document transfered"
      @clientSession.close
  end

end
