#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: IPSEC-generar-claves.sh 
# Descripcion: 	El objetivo de este script es generar el archivo ipsec.secrets para un tunel ipsec 
#		openswan dependiendo en tipo de tunel pasado por parámetro
# Parametros:
#		$1 - es el tipo de tunel a configurar
#		Valores posibles: 
#		- esp-psk: configura el tunel encriptado con claves compartidas
#		- esp-rsa: configura el tunel encriptado con claves RSA
#		- esp-cert: configura el tunel encriptado con clave RSA distribuidas en certificados
#		- ah: configura el tunel para hacer autenticacion
#		$2 - Hostname
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	1 - Parametros incorrectos
#	Ver valores de retorno de los archivos requeridos
#====================================================================================================
#Version log:
#-----------
#27/08/2006: Adaptacion: 
#	Juan Manuel Caracoche
#19/12/2005: Adaptacion:  
# 	Arias, Pablo.
# 	Rathonyi, Tibor.
# 	Wald, Guillermo.
# 	Wedefelt, Carl.
#
#06/06/2005: Creacion del script: 
#	Juan Manuel Caracoche
#
#=====================================================================================================

#Validacion de Parametros
if [ $# -ne 2 ] 
then
	(echo "USO: $0 TIPO_TUNEL HOST_NAME "
	echo "Valores posibles para TIPO_TUNEL: "
	echo -e "\t- esp-psk: configura el tunel encriptado con claves compartidas \n \
\t- esp-rsa: configura el tunel encriptado con claves RSA \n \
\t- esp-cert: configura el tunel encriptado con clave RSA distribuidas en certificados \n \
\t- ah: configura el tunel para hacer autenticacion \n" )
	exit 1
fi
	

#  Pre-Requisitos
CONF_FILE="/crypto/conf/config.sh"
FUNC_FILE="/crypto/lib/functions.sh"
if [ ! -e $FUNC_FILE -o ! -e $CONF_FILE ]
then
	echo "No se encontraron los archivos requeridos para ejecutar este script"
	echo -e "\t${CONF_FILE} \n\t${FUNC_FILE}"
fi

PARAM=$1
HOSTNAME=$2
. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi

Debug "usando archivo: $ARCHIVO_IPSEC_SEC"
BackupArch $ARCHIVO_IPSEC_SEC
rm -rf $ARCHIVO_IPSEC_SEC
CLAVE=""
case $PARAM in
	"esp-psk")
		until [ "$CLAVE" != "" ]; do
			echo -n "Ingrese la clave compartida (PSK): "
			read CLAVE
		done
		echo "$R1_PUB_IP $R2_PUB_IP: PSK \"$CLAVE\"" >> $ARCHIVO_IPSEC_SEC
	;;
	"esp-rsa")
		if [ "$HOSTNAME" == "$R1_HOSTNAME" ]; then
			ipsec newhostkey --output $ARCHIVO_IPSEC_SEC --hostname $R1_HOSTNAME
			ipsec showhostkey --left > $ARCHIVO_CLAVE_IPSEC_R1
		elif [ "$HOSTNAME" == "$R2_HOSTNAME" ]; then
			ipsec newhostkey --output $ARCHIVO_IPSEC_SEC --hostname $R2_HOSTNAME
			ipsec showhostkey --right > $ARCHIVO_CLAVE_IPSEC_R2
		fi
	;;
	"esp-cert")
		until [ "$CLAVE" != "" ]; do
			echo -n "Ingrese la clave del certificado correspondiente al host $HOSTNAME: "
			read CLAVE
		done
		Debug "Generando archivo de clave de IPsec $ARCHIVO_IPSEC_SEC con clave $CLAVE"
		#Si hay mas de un certificado se queda con el primero
		keyf=$(find $IP_CERTS_PATH/private | grep key |head -n1)
		echo ": RSA $keyf \"$CLAVE\"" > $ARCHIVO_IPSEC_SEC
	;;
	"ah")
	;;
	*)
	;;
esac
