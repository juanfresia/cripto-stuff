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

# Parametros de configuracion del Router1 (crypto-2)
R1_HOSTNAME="crypto-2"
R1_PUB_IFACE="enp0s9"
R1_PUB_IP="192.168.$GRUPO.41"

R1_PRIV_IFACE="enp0s8"
R1_PRIV_NET="10.$GRUPO.1.0/24"
R1_PRIV_IP="10.$GRUPO.1.1"
R1_SUBJECT_ID="C=${KEY_COUNTRY}, ST=${KEY_PROVINCE}, O=${KEY_ORG}, CN=${R1_HOSTNAME}"

# Parametros de configuracion del Router2 (crypto-3)
R2_HOSTNAME="crypto-3"
R2_PUB_IFACE="enp0s8"
R2_PUB_IP="192.168.$GRUPO.42"

R2_PRIV_IFACE="enp0s9"
R2_PRIV_NET="10.$GRUPO.2.0/24"
R2_PRIV_IP="10.$GRUPO.2.1"
R2_SUBJECT_ID="C=${KEY_COUNTRY}, ST=${KEY_PROVINCE}, O=${KEY_ORG}, CN=${R2_HOSTNAME}"

# Parametros de configuracion del Host2 (crypto-4)
H2_HOSTNAME="crypto-4"
H2_IP="10.$GRUPO.2.2"
