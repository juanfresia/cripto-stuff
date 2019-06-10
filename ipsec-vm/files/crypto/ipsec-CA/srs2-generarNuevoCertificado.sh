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


Debug "Generando un nuevo certificado. Ingresar los mismos datos que en el certificado previo (y mismo password)"
$D/build-key-pass r1n

Debug "Borrando certificado previo"
rm -f $IP_CERTS_PATH/certs/r1.pem
rm -f $IP_CERTS_PATH/private/r1.key

Debug "Instalando nuevo certificado"
cp -f $CAPATH/r1n.crt $IP_CERTS_PATH/certs/r1.pem
mv -f $CAPATH/r1n.key $IP_CERTS_PATH/private/r1.key
