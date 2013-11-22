Unoconv server configuration
================================

Here's a list of configurable variables for the Unoconv server.

- port => Defines the port in which the server listen for calls.
- ip => Defines the ip of the VM where the server is running.
- redirect_ip => The ip of the VM where the redirect server is running.
- redirect_port => The port in which the redirect server listen to new libreoffice servers.
- temp => Destination folder for temp files.
- uno => Unoconv's installation folder.
- converter => Destination folder for converted files.
- pid_file => File where the soffice process's PID is stored.
- url_bucket_put => URL of the S3 bucket (in the format that s3cmd uses), it's used to upload the converted file to AMAZON S3.
- url_bucket_post => URL of the S3 bucket (in the format a browser would use), it's sent to the API as a link to the converted file.
- uri => Notification controller's route.
- tar_name => tar_name + id it's the way the folder dir is compressed in the VM, because of this there can't be duplicated tar file
	      names.  
- port_size => Port used to notify redirect_server that a convertion ended (so it can update the server's load)

Execute
=======

To execute the unoconv server

- screen
- cd Document-Converter/unoconv
- ruby server_uno.rb

To detach screen session press ctr+alt+a and then press d.

To resume the screen, execute screen -r

To scroll into the screen, press crtl+a then press esc.
