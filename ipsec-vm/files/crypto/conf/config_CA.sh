#!/bin/sh
#------------------------------------------------------------------------------
# 		    66.69 - Criptografia y Seguridad Informatica
# 		Facultad de Ingenieria - Universidad de Buenos Aires
#------------------------------------------------------------------------------
# Scripts: config_CA.sh 
# Descripcion: 	El objetivo de este script es exportar todas las variables que 
#               luego usaran los distintos scripts relacionados con la 
#               Autoridad Certificante (CA)
# Parametros: No necesita
#
# Pre-Requisito: No tiene
#
# Valores de Retorno
#	0 - OK
#=============================================================================
#Version log:
#-----------
#29/01/2007: Creacion (basado en config.sh):
#       Alejandro Rusell
#
#=============================================================================

# parametros extra
OPERATING_PATH=/crypto/var
SCRIPT_PATH=/root
CAPATH=$OPERATING_PATH/rootCA
ROUTERS_PATH=$OPERATING_PATH/routers

# variables EASY-RSA
export D=/crypto/easy-rsa
export KEY_CONFIG="$D"/openssl.cnf
export KEY_DIR=$OPERATING_PATH/rootCA
export KEY_SIZE=1024
export KEY_COUNTRY=AR
export KEY_PROVINCE=BA
export KEY_CITY="Buenos Aires"
export KEY_ORG="66.69-Criptografia"
export KEY_EMAIL=""

