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

Debug "////////////////////////////////////////////////"
Debug "//  copiando zip con certificados desde router 1"
Debug "  scp vagrant@$R1_PUB_IP:$OPERATING_PATH/forr2.zip $OPERATING_PATH"
Debug "  (password is \"vagrant\")"
echo

scp vagrant@$R1_PUB_IP:$OPERATING_PATH/forr2.zip $OPERATING_PATH

mkdir -p $ROUTERS_PATH
Debug "Descompactando e instalando los certificados"
unzip -j $OPERATING_PATH/forr2.zip -d $ROUTERS_PATH

Debug "//////////////////////////////////////"
Debug "Instalando certificados en el router 2"

mkdir -p $IP_CERTS_PATH/certs

rm -f $IP_CERTS_PATH/certs/r2.pem
rm -f $IP_CERTS_PATH/private/r2.key
rm -f $IP_CERTS_PATH/cacerts/cacert.pem
rm -f $IP_CERTS_PATH/crl.pem

set -x
mv -f $ROUTERS_PATH/cacert.pem $IP_CERTS_PATH/cacerts
mv -f $ROUTERS_PATH/r2.pem $IP_CERTS_PATH/certs
mv -f $ROUTERS_PATH/r2.key $IP_CERTS_PATH/private
mv -f $ROUTERS_PATH/ids $OPERATING_PATH
mv -f $ROUTERS_PATH/crl.pem $IP_CERTS_PATH/crls
set +x

rm -f -r $ROUTERS_PATH

Debug "listo."
