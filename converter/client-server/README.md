client - server 
===============

Es un programa cliente servidor. Donde el servidor se conecta
con libreoffice en modo servidor para realizar la conversión de
un archivo. 
El cliente especifica el archivo a convertir y el al cuál lo desea
convertir.

Ejecución
---------

* Primero debe de levantarse un servidor escribiendo la siguiente 
línea en la consola: ruby server.rb

* Luego se corre el programa cliente en otra consola mediante la 
línea ruby client.rb

Funcionamiento
--------------

* importar socket : require 'socket'
Dado que se requieren sockets para establecer la conexión y 
enviar la solicitud, se utiliza la librería socket que debe
de ser importada en ambos programas mediante la sentencia
mencionada.

* crear socket:  TCPSocket.new( host, puerto )
El cliente crea un socket para conectarse con el servidor 
Donde host y puerto corresponden a los del servidor. 

* envío de solicitud : s.puts message
Se envían mesajes a través del socket mediante la función 
puts del socket. Donde "s" es un socket y deseamos enviar el 
mensaje "message", siendo este un string.

* recepción : s.gets
Se reciben mensajes a través del socket mediante la función gets
del socket. 

* cierre de conexión : s.closed

* creación de hilo : Thread.start do
		        ...
		     end
El servidor atiende varias solicitudes, entonces crea un hilo por 
cada solicitud. 

* ejecutar sobre una consola: system(command)
Para ejecutar un comando sobre una consola se utiliza la función system.
Donde "command" es un string que corresponde al comando que se desea 
ejecutar.

* escribir sobre consola : puts message
A modo de debugger se utiliza la función puts para escribir en la consola.
Donde message es un string que contiene lo que se desea imprimir.

* libreoffice : /usr/bin/libreoffice --headless --invisible --convert-to 
para ejecutar libreoffice en modo servidor se ejecuta el comando de arriba,
especificando la ruta del archivo a convertir y el tipo de formato deseado.
(ver ejemplos-libreoffice)



