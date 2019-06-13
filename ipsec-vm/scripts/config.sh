#!/bin/bash

GRUPO=5

export KEY_SIZE="1024"
export KEY_COUNTRY=AR
export KEY_PROVINCE=BA
export KEY_CITY="Buenos Aires"
export KEY_ORG="6669-Seguridad Redes"
export KEY_EMAIL=""

export CA_CN="grupo${GRUPO}"

# Parametros de configuracion del Host1 (crypto-1)
H1_HOSTNAME="crypto-1"
H1_IP="10.$GRUPO.1.2"
H1_MASCARA="255.255.255.0"

# Parametros de configuracion del Router1 (crypto-2)
R1_HOSTNAME="crypto-2"
R1_PUB_INTERFAZ="enp0s9"
R1_PUB_IP="192.168.$GRUPO.41"
R1_PUB_MASCARA="255.255.255.0"
R1_PRIV_INTERFAZ="enp0s8"
R1_PRIV_RED="10.$GRUPO.1.0"
R1_PRIV_IP="10.$GRUPO.1.1"
R1_PRIV_MASCARA="255.255.255.0"

# Parametros de configuracion del Router2 (crypto-3)
R2_HOSTNAME="crypto-3"
R2_PUB_INTERFAZ="enp0s8"
R2_PUB_IP="192.168.$GRUPO.42"
R2_PUB_MASCARA="255.255.255.0"
R2_PRIV_INTERFAZ="enp0s9"
R2_PRIV_RED="10.$GRUPO.2.0"
R2_PRIV_IP="10.$GRUPO.2.1"
R2_PRIV_MASCARA="255.255.255.0"

# Parametros de configuracion del Host2 (crypto-4)
H2_HOSTNAME="crypto-4"
H2_IP="10.$GRUPO.2.2"
H2_MASCARA="255.255.255.0"

# Variables para configuracion de IPSEC
## TODO: currently unused
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

