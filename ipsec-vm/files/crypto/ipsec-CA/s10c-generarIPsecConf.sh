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

TIPO_TUNEL=esp-cert
Debug "///////////////////////////////////"
Debug "///   Creando el Archivo ipsec.conf"
Debug "   $SCRIPTS_LIB/IPSEC-configurar.sh $TIPO_TUNEL"
$SCRIPTS_LIB/IPSEC-configurar.sh $TIPO_TUNEL

ERR=$?
Debug "listo."
exit $ERR
