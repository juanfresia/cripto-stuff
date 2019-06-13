#!/bin/bash
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: IPSEC-configurar.sh 
# Descripcion: 	El objetivo de este script es generar el archivo ipsec.conf 
#               para un tunel ipsec openswan dependiendo el tipo de tunel 
#		pasado por parametro
# Parametros:
#		$1 - es el tipo de tunel a configurar
#		Valores posibles: 
#		- esp-psk: configura el tunel encriptado con claves compartidas
#		- esp-rsa: configura el tunel encriptado con claves RSA
#		- esp-cert: configura el tunel encriptado con clave RSA distribuidas en certificados
#		- ah: configura el tunel para hacer autenticacion
#		Valor default: Si no se pasa parametros se configura como "esp-psk"
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	1 - Parametros incorrectos
#	Ver valores de retorno de los archivos requeridos
#==============================================================================
#Version log:
#-----------
#29/01/2008: Adaptacion: 
#	Alejandro Rusell
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
#==============================================================================

#Validacion de Parametros
if [ $# -gt 1 ] 
then
	(echo "USO: $0 [TIPO_TUNEL]"
	echo "Valores posibles: "
	echo -e "\t- esp-psk: configura el tunel encriptado con claves compartidas \n \
\t- esp-rsa: configura el tunel encriptado con claves RSA \n \
\t- esp-cert: configura el tunel encriptado con clave RSA distribuidas en certificados \n \
\t- ah: configura el tunel para hacer autenticacion \n \
\tValor default: Si no se pasa parametros se configura como \"esp-psk\"")
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

. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi

Debug "Archivo de configuracion IPSEC: $ARCHIVO_IPSEC"

# Genero el archivo de configuracion IPSEC

# Primero borro el actual
BackupArch $ARCHIVO_IPSEC
rm -f $ARCHIVO_IPSEC
(
# Configuracion General
echo "version 2.0"
echo "config setup"
echo "	interfaces=\"ipsec0=$R1_PUB_INTERFAZ\""
#echo "	interfaces=%defaultroute"
echo "	klipsdebug=none"
echo "	plutodebug=none"
#echo "	plutoload=%search"
#echo "	plutostart=%search"
echo "	uniqueids=yes"
echo "	forwardcontrol=yes"
echo ""
# Conexion Default
echo "conn %default"
echo "	keyingtries=0"
echo "	disablearrivalcheck=no"
echo ""
# Conexion R1-R2
echo "conn crypto"
echo "	left=$R1_PUB_IP"
echo "	leftsubnet=$R1_PRIV_RED/$R1_PRIV_MASCARA"
echo "	right=$R2_PUB_IP"
echo "	rightsubnet=$R2_PRIV_RED/$R2_PRIV_MASCARA"
echo "	auto=add"


) > $ARCHIVO_IPSEC

case $PARAM in
	"esp-psk")
		(echo "	authby=secret"
		echo "	auth=esp") >> $ARCHIVO_IPSEC
	;;
	"esp-rsa")
		Debug "Leyendo clave de R1..."
		if [ -f  $ARCHIVO_CLAVE_IPSEC_R1 ]; then
			LEFTKEY=`cat $ARCHIVO_CLAVE_IPSEC_R1`
		else Debug "ERROR: No existe  $ARCHIVO_CLAVE_IPSEC_R1";
		fi
		Debug "Leyendo clave de R2..."
		if [ -f  $ARCHIVO_CLAVE_IPSEC_R2 ]; then
			RIGHTKEY=`cat $ARCHIVO_CLAVE_IPSEC_R2`
		else Debug "ERROR: No existe  $ARCHIVO_CLAVE_IPSEC_R2";
		fi
		(echo "	authby=rsasig"
		echo "	auth=esp"
		echo "$RIGHTKEY"
		echo "$LEFTKEY") >> $ARCHIVO_IPSEC
	;;
	"esp-cert")
		(
		echo "	auth=esp"
		echo "	authby=rsasig"
		echo "	leftrsasigkey=%cert"
		echo "	rightrsasigkey=%cert"
		echo "	leftcert=$IP_CERTS_PATH/certs/${R1_HOSTNAME}.pem"
		echo "	rightcert=$IP_CERTS_PATH/certs/${R2_HOSTNAME}.pem"
		) >> $ARCHIVO_IPSEC
		cat $OPERATING_PATH/ids >> $ARCHIVO_IPSEC
	;;
	"ah")
	;;
	*)
		#El default si no se pasa nada por parametro es "esp-psk"
		(echo "  authby=secret"
		echo "  auth=esp") >> $ARCHIVO_IPSEC
	;;

esac
exit 0
	

