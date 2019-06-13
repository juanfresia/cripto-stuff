#!/bin/bash
#  Pre-Requisitos
CONF_FILE="../conf/config.sh"
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

echo
Debug "/////////////////////////////////////////////////////"
Debug "Borrando previos certificados en $IP_CERTS_PATH/certs"
rm -f $IP_CERTS_PATH/cacerts/cacert.pem
rm -f $IP_CERTS_PATH/certs/${R1_HOSTNAME}.pem
rm -f $IP_CERTS_PATH/certs/${R2_HOSTNAME}.pem
rm -f $IP_CERTS_PATH/private/${R1_HOSTNAME}.key
rm -f $IP_CERTS_PATH/crls/crl.pem


Debug "Instalando los certificados al router 1"
set -x
mkdir -p $IP_CERTS_PATH/certs
mkdir -p $IP_CERTS_PATH/cacerts
mkdir -p $IP_CERTS_PATH/private
mkdir -p $IP_CERTS_PATH/crls
cp -f $CAPATH/ca.crt $IP_CERTS_PATH/cacerts/cacert.pem
cp -f $CAPATH/crl.pem $IP_CERTS_PATH/crls
cp -f $ROUTERS_PATH/${R1_HOSTNAME}.pem $IP_CERTS_PATH/certs
cp -f $ROUTERS_PATH/${R1_HOSTNAME}.key $IP_CERTS_PATH/private
set +x
Debug "listo."





