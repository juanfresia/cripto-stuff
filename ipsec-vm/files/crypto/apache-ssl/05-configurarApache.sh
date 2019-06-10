#!/bin/sh
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: 07-instala_sitio.sh
# Descripcion: Crea los archivos del sitio, modifica la configuracion del 
#              apache y lo recarga.
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
#2009 hpg
#01/29/2007: Creacion del script: Alejandro J. Rusell
#
#==============================================================================

FUNC_FILE="../lib/functions.sh"
. ${FUNC_FILE}
if [ $? -ne 0 ]; then
	exit $?
fi

PORTS_FILE=/etc/apache2/ports.conf
PORT=443
Debug "/////////////////////////////////////////////////////"
Debug "Configurando puerto $PORT del apache en ${PORTS_FILE}"


grep ${PORT} ${PORTS_FILE} > /dev/null 2>&1
if [ $? -ne 0 ]; then
        # not found, add
        Debug "Agregando el puerto ${PORT}"
        echo "Listen ${PORT}" >> ${PORTS_FILE}
else
        Debug "El puerto ${PORT} ya esta configurado"
fi

echo
Debug "/////////////////////////////////////////////////////"
Debug "Habilitando el modulo mod_ssl"
echo "a2enmod ssl"
a2enmod ssl

#Debug "Automatizando la carga de la passphrase para el certificado."
# solo es necesario si la key del servidor tiene clave
#grep SSLPassPhraseDialog /etc/apache2/httpd.conf > /dev/null 2>&1
#if [ $? -ne 0 ]; then
#        echo "SSLPassPhraseDialog exec:/crypto/conf/apache/.key.sh" >> /etc/apache2/httpd.conf
#fi


Debug "Agregando la definicion del sitio al apache"
echo " cp -f data/ssl-site.conf /etc/apache2/sites-available/ssl-site"
cp -f data/ssl-site.conf /etc/apache2/sites-available/ssl-site

Debug "Las paginas del sitio SSL estan en /crypto/var/www"
#Debug "Creando el sitio ssl"
#tar -C/var/sites -zxvf data/ssl-data.tgz 

Debug "Habilitando el sitio al apache"
echo "a2ensite ssl-site"
a2ensite ssl-site

Debug "Configurando ssl-server como 127.0.1.2 en archivo hosts"
grep ssl-server /etc/hosts > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "127.0.1.2	ssl-server" >> /etc/hosts
fi

Debug "Listo"

