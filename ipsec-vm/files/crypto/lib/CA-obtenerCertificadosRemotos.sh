#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: CA-ObtenerCertificadosRemotos.sh 
# Descripcion: 	El objetivo de este script es obtener el juego de certificado del router pasado por
#		parametro y con la informacion de los dos generar los ids de cada router
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

[ -d $IP_CERTS_PATH/certs ] || mkdir -p $IP_CERTS_PATH/certs

Debug "Obteniendo los certificados remotos"
case "$HOSTNAME" in
	"$R1_HOSTNAME")
		scp root@$R1_PUB_IP:$OPERATING_PATH/for${R2_HOSTNAME}.tar $OPERATING_PATH
		tar -xvpf $OPERATING_PATH/for${R2_HOSTNAME}.tar -C $ROUTERS_PATH
		Debug "Instalando los certivicados remotos"
		mv -f $ROUTERS_PATH/cacert.pem $IP_CERTS_PATH/cacerts
		mv -f $ROUTERS_PATH/${R1_HOSTNAME}.pem $IP_CERTS_PATH/certs
		mv -f $ROUTERS_PATH/${R1_HOSTNAME}.key $IP_CERTS_PATH/private

	;;
	"$R2_HOSTNAME")
		scp root@$R1_PUB_IP:$OPERATING_PATH/for${R1_HOSTNAME}.tar $OPERATING_PATH
		tar -xvpf $OPERATING_PATH/for${R1_HOSTNAME}.tar -C $ROUTERS_PATH
		Debug "Instalando los certivicados remotos"
		mv -f $ROUTERS_PATH/cacert.pem $IP_CERTS_PATH/cacerts
		mv -f $ROUTERS_PATH/${R2_HOSTNAME}.pem $IP_CERTS_PATH/certs
		mv -f $ROUTERS_PATH/${R2_HOSTNAME}.key $IP_CERTS_PATH/private

	;;
esac
Debug "listo."
