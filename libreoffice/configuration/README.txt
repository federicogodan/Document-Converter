Libreoffice server configuration
================================

Here's a list of configurable variables for the Libreoffice server.

- port => Defines the port in which the server listen for calls.
- ip => Defines the ip of the VM where the server is running.
- redirect_ip => The ip of the VM where the redirect server is running.
- redirect_port => The port in which the redirect server listen to new libreoffice servers.
- temp => Destination folder for temp files.
- libreoffice => Libreoffice's installation folder.
- converter => Destination folder for converted files.
- pid_file => File that where it gets saved the process id for the soffice process.
- url_bucket_put => URL of the S3 bucket (in the format that s3cmd uses), it's used to upload the converted file to AMAZON S3.
- url_bucket_post => URL of the S3 bucket (in the format a browser would use), it's sent to the API as a link to the 
	             uploaded file.
- uri => Route for the notification controller.
- name_temp_file => name_temp_file + id it's the way the temp file is stored in the VM, this way there can't be duplicated 
		    temp files names.  
- port_size => Port used to notify redirect_server that a convertion ended (so it can update the server's load)
- retries => Number of retries when a convertion fails.

Execute
=======

To execute the libreoffice server

- screen
- cd Document-Converter/libreoffice
- ruby libreoffice.rb

To detach screen session press ctr+alt+a and then press d.

To resume the screen, execute screen -r

To scroll into the screen, press crtl+a then press esc.


