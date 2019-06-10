#!/bin/sh
#------------------------------------------------------------------------------
#		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: 05-configurar_puerto_ssl.sh
# Descripcion:  Agrega el puerto 443 (HTTPS) a la configuracion del apache
# Parametros: Ninguno
#
# Pre-Requisito: archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	Ver valores de retorno de los archivos requeridos
#==============================================================================
#Version log:
#-----------
#
#01/29/2007: Creacion del script: 
#	Alejandro J. Rusell
#
#==============================================================================

PORTS_FILE=/etc/apache2/ports.conf
PORT=443

FUNC_FILE="../lib/functions.sh"
. ${FUNC_FILE}
if [ $? -ne 0 ]; then
	exit $?
fi

grep ${PORT} ${PORTS_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
	# not found, add
	Debug "Agregando el puerto ${PORT}"
	/usr/bin/sudo echo "Listen ${PORT}" >> ${PORTS_FILE}
else
	Debug "El puerto ${PORT} ya esta configurado"
fi

