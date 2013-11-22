Libreoffice server configuration
================================

Here's a list of configurable variables for the Libreoffice server.

- port => Defines the port in which the server listens to calls.
- ip => Defines the ip of the VM where the server is running.
- redirect_ip => The ip of the VM where the redirect server is running.
- redirect_port => The port in which the redirect server listens to new Libreoffice servers.
- temp => Destination folder for temp files.
- libreoffice => Libreoffice's installation folder.
- converter => Destination folder for converted files.
- pid_file => File where the soffice process's PID is stored.
- url_bucket_put => URL of the S3 bucket (in the format that s3cmd uses). It's used to upload the converted file to AMAZON S3.
- url_bucket_post => URL of the S3 bucket (in the format a browser would use). It's sent to the API as a link to the 
	             uploaded file.
- uri => Route for the notification controller.
- name_temp_file => name_temp_file + id .It's the way the temp file is stored in the VM, this way there can't be duplicated 
		    temp file names.  
- port_size => Port used to notify redirect_server that a conversion ended (so it can update the server's load)
- retries => Number of retries when a conversion fails.
