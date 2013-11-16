
Ejecución del 'redirect_server' 
-------------------------------
* configuración : editar archivo de configuración redirect.properties
parámetros: 
port_clients --->puerto donde se atienden clientes
port_servers --->puerto donde se conectan los servidores para 			 avisar que están disponibles


* ejecución: ruby redirect_server.rb

Ejecución del 'server'
----------------------
*configuración : editar archivo de configuración server.propierties
parámetros:
ip-------------->ip donde se ejecuta el servidor
redirect_ip----->ip donde se ejecua el redirecy_server
redirect_port--->puerto en el cual el redirect_server escucha a los servidores
temp ------------>ruta para archivos temporales del servidor 
libreoffice ----->ruta de instancia de libreoffice que será ejecutada por el servidor
converted ------->ruta donde se guardarán los archivos convertidos
pid_file--------->nombre de archivo donde se guardará el pid del proceso libreoffice al ejecutar el comando para realizar la 			  conversión
*ejecución : ruby server.rb puerto 

Ejecución del 'client'
---------------------
Esto se realizó para realizar pruebas sin la necesidad de poseer la aplicación web corriendo. 
*configuración : editar archivo de configuración client.properties
parámetros:
file_path-------->ruta completa del archivo a convertir
format----------->formato destino
file_name ------->nombre completo del archivo
size ------------>tamaño en bytes del archivo
redirect_ip ----->ip de donde se está ejecutando el redirect_server
redirect_port---->puerto de donde se está ejecutando el redirect_server
Observaciones: 
para obtener el tamaño del archivo se puede ejecutar el siguiente comando : 
du -b archivo  

Ejecución del 'server_uno'
--------------------------
*configuración : editar archivo de configuración server.propierties
parámetros:
ip-------------->ip donde se ejecuta el servidor
redirect_ip----->ip donde se ejecua el redirecy_server
redirect_port--->puerto en el cual el redirect_server escucha a los servidores
temp ------------>ruta para archivos temporales del servidor
uno ----->ruta de instancia de unoconv que será ejecutada por el servidor
converted ------->ruta donde se guardarán los archivos convertidos
pid_file--------->nombre de archivo donde se guardará el pid del proceso libreoffice al ejecutar el comando para realizar la conversión
tar_name--------->nombre del archivo tar donde se almacenarán los archivos convertidos
*ejecución : ruby server_uno.rb puerto


		
