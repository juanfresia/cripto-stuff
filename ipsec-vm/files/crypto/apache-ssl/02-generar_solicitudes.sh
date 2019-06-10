#!/bin/sh
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: 02-generar_solicitudes.sh
# Descripcion: Genera un par de claves y la solicitud de certificado.
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


Debug "Removiendo previos certificados"
rm -r -f $ROUTERS_PATH
mkdir $ROUTERS_PATH

Debug "Generando peticiones de firma para servidor"
$D/build-req ssl-server

Debug "listo."

