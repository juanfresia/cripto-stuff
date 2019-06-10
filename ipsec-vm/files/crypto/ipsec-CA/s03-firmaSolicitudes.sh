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
Debug "Ejecutando $D/sign-req r1"
$D/sign-req r1

echo
Debug "////////////////////////////////"
Debug "////   Firmando los certificados"
Debug "Ejecutando $D/sign-req r2"
$D/sign-req r2

echo
Debug "///////////////////////////////////////////"
Debug "copiando los certificados y moviendo claves"
set -x
cp $CAPATH/r1.crt $ROUTERS_PATH/r1.pem
cp $CAPATH/r2.crt $ROUTERS_PATH/r2.pem
mv $CAPATH/r1.key $ROUTERS_PATH
mv $CAPATH/r2.key $ROUTERS_PATH
set +x

Debug "listo."



