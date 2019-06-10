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


Debug "Borrando posibles previas autoridades certificantes"
Debug "ejecutando $D/clean-all"
$D/clean-all

Debug "////////////////////////////////////////////"
Debug "//// Generando nueva autoridad certificante"
Debug "ejecutando $D/build-ca"
Debug "////////////////////////////////////////////"

$D/build-ca

Debug "listo."

