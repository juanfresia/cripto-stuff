#!/bin/sh
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: 04-instalar_certificados.sh
# Descripcion: Reinicia apache forzando la carga de la nueva configuracion.
# Parametros: Ninguno
#
# Pre-Requisito: archivo de configuracion de CA y archivo de funciones
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

CONF_FILE="../conf/config_CA.sh"
FUNC_FILE="../lib/functions.sh"

if [ ! -e $FUNC_FILE -o ! -e $CONF_FILE ]
then
	echo "No se encontraron los archivos requeridos para ejecutar este script"
	echo -e "\t${CONF_FILE} \n\t${FUNC_FILE}"
fi

PARAM=$1

. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi

APACHE_CERTS_DIR=/crypto/conf/apache/crt/

Debug "Borrando previos certificados"
if [ ! -d ${APACHE_CERTS_DIR} ]; then
	Debug "Creando el directorio de certificados"
	mkdir -p $IP_CERTS_PATH
fi

rm -f ${APACHE_CERTS_DIR}/* 2>/dev/null

Debug "Instalando los certificados del servidor ssl-server"
cp -f ${CAPATH}/ca.crt ${APACHE_CERTS_DIR}/ca.crt
mv -f ${ROUTERS_PATH}/ssl-server.pem ${APACHE_CERTS_DIR}/ssl-server.crt
mv -f ${ROUTERS_PATH}/ssl-server.key ${APACHE_CERTS_DIR}/ssl-server.key

Debug "listo."

