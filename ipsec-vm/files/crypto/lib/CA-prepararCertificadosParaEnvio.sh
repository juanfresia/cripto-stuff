#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: CA-prepararCertificadosParaEnvio.sh 
# Descripcion: 	El objetivo de este script es preparar un paquete con los certificados para ser enviados
#		al host remoto cuando lo solicite
# Parametros: Nombre del Host
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	1 - Parametros incorrectos
#	Ver valores de retorno de los archivos requeridos
#====================================================================================================
#Version log:
#-----------
#27/08/2006: Adaptacion: 
#	Juan Manuel Caracoche
#10/08/2006: Creacion:  
#	Nicolas Sobotovsky
#=====================================================================================================
#Validacion de Parametros
if [ $# -ne 1 ] 
then
	echo "USO: $0 HOST_NAME "
	exit 1
fi

#  Pre-Requisitos
CONF_FILE="/crypto/conf/config.sh"
FUNC_FILE="/crypto/lib/functions.sh"
if [ ! -e $FUNC_FILE -o ! -e $CONF_FILE ]
then
	echo "No se encontraron los archivos requeridos para ejecutar este script"
	echo -e "\t${CONF_FILE} \n\t${FUNC_FILE}"
fi

$HOSTNAME=$1
. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi


Debug "Perparando archivo para host remoto"
case "$HOSTNAME" in
	"R1_HOSTNAME")
		cp -f $CAPATH/ca.crt $ROUTERS_PATH/cacert.pem
		cp -f $CAPATH/crl.pem $ROUTERS_PATH
		cp -f $OPERATING_PATH/ids $ROUTERS_PATH
		tar -cvf $OPERATING_PATH/for${R2_HOSTNAME}.tar  $ROUTERS_PATH/*
	;;
	"R2_HOSTNAME")
		cp -f $CAPATH/ca.crt $ROUTERS_PATH/cacert.pem
		cp -f $CAPATH/crl.pem $ROUTERS_PATH
		cp -f $OPERATING_PATH/ids $ROUTERS_PATH
		tar -cvf $OPERATING_PATH/for${R2_HOSTNAME}.tar  $ROUTERS_PATH/*
	;;
esac
Debug "listo."
