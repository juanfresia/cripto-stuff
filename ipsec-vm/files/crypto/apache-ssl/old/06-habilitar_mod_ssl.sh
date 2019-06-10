#!/bin/sh
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: 06-habilitar_mod_ssl.sh
# Descripcion: Habilita el modulo mod_ssl y configura apache para leer la 
#              passphrase de la clave privada desde un script.
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

FUNC_FILE="../lib/functions.sh"
. ${FUNC_FILE}
if [ $? -ne 0 ]; then
	exit $?
fi

Debug "Habilitando el modulo mod_ssl"
/usr/bin/sudo a2enmod ssl
Debug "Automatizando la carga de la passphrase para el certificado."
grep SSLPassPhraseDialog /etc/apache2/httpd.conf > /dev/null 2>&1
if [ $? -ne 0 ]; then
	/usr/bin/sudo echo "SSLPassPhraseDialog exec:/crypto/conf/apache/.key.sh" >> /etc/apache2/httpd.conf
fi

