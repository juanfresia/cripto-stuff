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

Debug "////////////////////////////////////"
Debug "Obteniendo datos de los certificados"

idleft=`grep "Subject:" $ROUTERS_PATH/r1.pem |cut -d: -f 2`
idright=`grep "Subject:" $ROUTERS_PATH/r2.pem |cut -d: -f 2`


rm -f $OPERATING_PATH/ids
(
echo "	leftid=\"${idleft:1}\""
echo "	rightid=\"${idright:1}\""
) > $OPERATING_PATH/ids

cat $OPERATING_PATH/ids
Debug "listo."
