#! /bin/bash

#  Pre-Requisitos
CONF_FILE="../conf/config.sh"
FUNC_FILE="../lib/functions.sh"
if [ ! -e $FUNC_FILE -o ! -e $CONF_FILE ]
then
        echo "No se encontraron los archivos requeridos para ejecutar este scrip   t"
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
Debug "/////////////////////////////////////////////"				
Debug "Perparando archivo para host remoto, router 2"
set -x
cp -f $CAPATH/ca.crt $ROUTERS_PATH/cacert.pem
cp -f $CAPATH/crl.pem $ROUTERS_PATH
cp -f $OPERATING_PATH/ids $ROUTERS_PATH

zip $OPERATING_PATH/forr2.zip -r $ROUTERS_PATH
set +x

Debug "Borrando directorio"

rm -r -f $ROUTERS_PATH

Debug "listo."
