Document-Converter
==================

PIS 2013

Converter - prototipo para conversión de archivo
-------------------------------------------------

Sistema que convierte un archivo a través de una página web, conectándose con un servidor 
el cuál se encarga de ejecutar el programa libreoffice en modo servidor para convertir el 
archivo deseado.

Cuando se ingresa al sitio web, el cliente selecciona el archivo a convertir y el formato. 
Cuando presiona el botón, se crea una conección TCP con el servidor (el cuál debe de estar 
previamente corriendo en determinado puerto) para luego enviarle la solicitud de convertir 
el archivo especificando su formato.
El servidor recibe estos parámetros y ejecuta un comando para levantar libreoffice en modo 
servidor y poder realizar la conversión.

Funcionamiento:

* Cliente
El cliente es ejecutado dentro del controlador en la función create, la misma es invocada 
cuando se presiona el botón del formulario a través del cuál se obtienen los parámetros 
necesarios para realizar la solicitud de conversión (archivo y formato).


* Servidor
El servidor debe de estar levantado desde una consola a través del comando : ruby server.rb
De esta forma se quedará escuchando en un puerto, esperando a que un cliente se conecte. 
Cuando recibe una petición del cliente, ejecuta un comando para realizar la conversión y 
le envía ack al cliente para informarle que recibió la petición. Luego envía un mensaje 
para informarle al cliente que puede cerrar la conexión pues se finalizó la conversión del
archivo. En un futuro, el servidor debería devolver el archivo convertido. 


#14/09/2013
Observaciones: 

* Hasta el momento, se está realizando la conversión de un arhivo de ruta conocida por el
servidor, dado que aún no se ha logrado realizar el pasaje a través del socket de manera 
correcta,  es decir de tal forma que el servidor reciba el archivo original correctamente. 

* Se sabe que el archivo al ser enviado a través del formulario queda guardado como un archivo 
temporal en la ruta /tmp. Dicho archivo no posee la misma extención del archivo original y 
tampoco posee el mismo nombre.

* Se debe investigar acerca de cuál sería la manera correcta de enviar a través del socket 
el archivo recibido del formulario.

 
 
