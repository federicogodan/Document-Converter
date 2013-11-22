Redirect server configuration
=============================

port_servers_unoconv => Port where the server listens to new unoconv servers.
port_servers_libreoffice => Port where the server listens to new Libreoffice servers.
port_unoconv => Port where the server listens to unoconv conversion requests from the API.
port_libreoffice => Port where the server listens to Libreoffice conversion requests from the API.
port_size => Port where the server listens to completed or failed conversions.

Execute
=======

To execute the redirect server

- screen
- cd Document-Converter/redirect
- ruby redirect_server.rb

To detach screen session press ctr+alt+a and then press d.

To resume the screen, execute screen -r

To scroll into the screen, press crtl+a then press esc.

