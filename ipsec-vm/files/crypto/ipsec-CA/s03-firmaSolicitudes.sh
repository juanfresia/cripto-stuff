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
Debug "////////////////////////////////"
Debug "////   Firmando los certificados"
Debug "Ejecutando $D/sign-req ${R1_HOSTNAME}"
$D/sign-req ${R1_HOSTNAME}

echo
Debug "////////////////////////////////"
Debug "////   Firmando los certificados"
Debug "Ejecutando $D/sign-req ${R2_HOSTNAME}"
$D/sign-req ${R2_HOSTNAME}

echo
Debug "///////////////////////////////////////////"
Debug "copiando los certificados y moviendo claves"
set -x
cp $CAPATH/${R1_HOSTNAME}.crt $ROUTERS_PATH/${R1_HOSTNAME}.pem
cp $CAPATH/${R2_HOSTNAME}.crt $ROUTERS_PATH/${R2_HOSTNAME}.pem
mv $CAPATH/${R1_HOSTNAME}.key $ROUTERS_PATH
mv $CAPATH/${R2_HOSTNAME}.key $ROUTERS_PATH
set +x

Debug "listo."



