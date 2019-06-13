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


Debug "Removiendo previos certificados"
rm -r -f $ROUTERS_PATH
mkdir $ROUTERS_PATH
Debug "///////////////////////////////////////////"
Debug "Generando peticiones de firma para router 1"
Debug "/// Ejecutando $D/build-req-pass ${R1_HOSTNAME}"

$D/build-req-pass ${R1_HOSTNAME}

Debug "///////////////////////////////////////////"
Debug "Generando peticiones de firma para router 2"
Debug "/// Ejecutando $D/build-req-pass ${R2_HOSTNAME}"
$D/build-req-pass ${R2_HOSTNAME}

Debug "listo."
