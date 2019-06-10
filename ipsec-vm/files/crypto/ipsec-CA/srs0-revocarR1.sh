#! /bin/bash

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



Debug "Revocando certificado del router 1"
$D/revoke-full r1

Debug "Instalando nueva lista de certificados revocados en el equipo local"
rm -f $IP_CERTS_PATH/crls/crl.pem
cp -f $CAPATH/crl.pem $IP_CERTS_PATH/crls
