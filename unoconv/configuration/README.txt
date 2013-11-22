Unoconv server configuration
================================

Here's a list of configurable variables for the Unoconv server.

- port => Defines the port in which the server listens to calls.
- ip => Defines the ip of the VM where the server is running.
- redirect_ip => The ip of the VM where the redirect server is running.
- redirect_port => The port in which the redirect server listens to new Libreoffice servers.
- temp => Destination folder for temp files.
- uno => Unoconv's installation folder.
- converter => Destination folder for converted files.
- pid_file => File where the soffice process's PID is stored.
- url_bucket_put => URL of the S3 bucket (in the format that s3cmd uses). It's used to upload the converted file to AMAZON S3.
- url_bucket_post => URL of the S3 bucket (in the format a browser would use). It's sent to the API as a link to the converted file.
- uri => Notification controller's route.
- tar_name => tar_name + id . It's the way the folder dir is compressed in the VM. Because of this, there can't be duplicated tar file
	      names.  
- port_size => Port used to notify redirect_server that a conversion ended (so it can update the server's load)
