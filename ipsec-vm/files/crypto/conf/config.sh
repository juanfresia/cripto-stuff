#!/bin/bash
#-----------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: config.sh 
# Descripcion: 	El obejetivo de este script es exportar todas la variables que 
#               luego usaran los distintos scripts
# Parametros: No necesita
#
# Pre-Requisito: No tiene
#
# Valores de Retorno
#	0 - OK
#	300 - Debe cambiar el numero de grupo
#	301 - La variable grupo debe ser numerica y entre 0 y 255
#	Ver valores de retorno de los archivos requeridos
#==============================================================================
#Version log:
#-----------
#23/04/2009: Hugo Pagola definicion de eth1 como privada quitando eth0:0
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
#=====================================================================================================

# Variables de grupo
GRUPO="5"

if [[ $GRUPO == *[a-Z] || $GRUPO -lt 0 || $GRUPO -gt 255 ]]
then
	echo "El numero de grupo debe ser numerico y mayor a 0 y menor o igual a 255"
        echo "Verificar variable GRUPO en Archivo /crypto/conf/config.sh"
	exit 301
fi

# parametros extra
OPERATING_PATH=/crypto/var
SCRIPT_PATH=/root
CAPATH=$OPERATING_PATH/rootCA
ROUTERS_PATH=$OPERATING_PATH/routers
IP_CERTS_PATH=/etc/ipsec.d

# variables EASY-RSA
export D=/crypto/easy-rsa
export KEY_CONFIG="$D"/openssl.cnf
export KEY_DIR=$OPERATING_PATH/rootCA
export KEY_SIZE=1024
export KEY_COUNTRY=AR
export KEY_PROVINCE=BA
export KEY_CITY="Buenos Aires"
export KEY_ORG="6669-Seguridad Redes"
export KEY_EMAIL=""


# Parametros de configuracion del Host1
H1_HOSTNAME="crypto-1"
H1_IP="10.$GRUPO.1.2"
H1_MASCARA="255.255.255.0"

# Parametros de configuracion del Router1
R1_HOSTNAME="crypto-2"
R1_PUB_INTERFAZ="enp0s9"
R1_PUB_IP="192.168.$GRUPO.41"
R1_PUB_MASCARA="255.255.255.0"
R1_PRIV_INTERFAZ="enp0s8"
R1_PRIV_RED="10.$GRUPO.1.0"
R1_PRIV_IP="10.$GRUPO.1.1"
R1_PRIV_MASCARA="255.255.255.0"

# Parametros de configuracion del Host2
H2_HOSTNAME="crypto-4"
H2_IP="10.$GRUPO.2.2"
H2_MASCARA="255.255.255.0"

# Parametros de configuracion del Router2
R2_HOSTNAME="crypto-3"
R2_PUB_INTERFAZ="enp0s8"
R2_PUB_IP="192.168.$GRUPO.42"
R2_PUB_MASCARA="255.255.255.0"
R2_PRIV_INTERFAZ="enp0s9"
R2_PRIV_RED="10.$GRUPO.2.0"
R2_PRIV_IP="10.$GRUPO.2.1"
R2_PRIV_MASCARA="255.255.255.0"

# Variables para configuracion de IPSEC
SCRIPTS_LIB="/crypto/lib"
DIR_CLAVES_IPSEC="/tmp"
ARCHIVO_CLAVE_IPSEC_R1="$DIR_CLAVES_IPSEC/left.key"
ARCHIVO_CLAVE_IPSEC_R2="$DIR_CLAVES_IPSEC/right.key"
#Valores posibles: 
# - esp-psk: configura el tunel encriptado con claves compartidas
# - esp-rsa: configura el tunel encriptado con claves RSA
# - esp-cert: configura el tunel encriptado con clave RSA distribuidas en certificados
# - ah: configura el tunel para hacer autenticacion
TIPO_TUNEL="esp-rsa"	

# Variables generales
ARCHIVO_HOSTS="/etc/hosts"
ARCHIVO_IPSEC="/etc/ipsec.conf"
ARCHIVO_IPSEC_SEC="/etc/ipsec.secrets"
