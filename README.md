Document-Converter
==================

PIS 2013
PARA INSTALAR LA GEMA LOCALMENTE
1) Abrir una consola en la carpeta 'doc_converter'
2) Generar la gema con el siguiente comando
	$gem build doc_converter.gemspec
3) Instalar la gema de forma local
	$gem install doc_converter-0.0.1.gem
PARA USAR LA GEMA
1) Abrir la consola de ruby:
	$irb
2) Incluir la gema:
	$require 'doc_converter'
3) Que la magia suceda:
	i - Para obtener los formatos a los que puedo convertirse un archivo en determinado formato
		$DocConverter.get_formats("formato")
	ii- Para convertir un archivo
		$DocConverter.convert_document("ruta_absoluta_archivo", "extension_destino")