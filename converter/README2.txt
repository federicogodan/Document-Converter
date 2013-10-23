#22/10/2013
* En la carpeta servers se encuentran los archivos
server.rb
redirect_server.rb
client.rb
con sus respectivos archivos de configuración 
Allí hay un txt que explica la ejecución 
Este servidor solamente soporta una instancia de libreoffice
* En la carpeta pruebas están las pruebas realizadas en amazon 
donde se probo con dos instancias de libreoffice 


####TODO: 
- Servidor unoconv (idem pero ejecutará un comando de unoconv)
- Gestión de colas en redirect_server
- Integración con s3
- Terminar integración devise (está en proyecto devise la parte del controlador, faltaría probarlo ejecutando un servidor desde acá y verificando la conversión)
