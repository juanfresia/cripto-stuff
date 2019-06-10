#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: IPSEC-copiarClaveRemota.sh 
# Descripcion: 	El objetivo de este script es copiar la clave del router pasado por parámetro 
# Parametros:
#		$1 - Hostname
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	1 - Parametros incorrectos
#	2 - Error Copiando archivo remoto
#	Ver valores de retorno de los archivos requeridos
#====================================================================================================
#Version log:
#-----------
#23/04/2009 Hugo Pagola error en lineas 64 y 69 nombres de archivo invertidos
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
if [ $# -ne 1 ] 
then
	echo "USO: $0 HOST_NAME "
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

HOSTNAME=$1
. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi


case "$HOSTNAME" in
	"$R1_HOSTNAME")
		ARCH=$ARCHIVO_CLAVE_IPSEC_R1
		scp root@$R1_HOSTNAME:$ARCHIVO_CLAVE_IPSEC_R1 $ARCHIVO_CLAVE_IPSEC_R1
		ERROR=$?
		;;
	"$R2_HOSTNAME")
		ARCH=$ARCHIVO_CLAVE_IPSEC_R2
		scp root@$R2_HOSTNAME:$ARCHIVO_CLAVE_IPSEC_R2 $ARCHIVO_CLAVE_IPSEC_R2	
		ERROR=$?
		;;
	*) 	echo "USO: $0 HOST_NAME "
		;;
esac

if [ $ERROR -eq 0 ]
then
  Debug "Clave IPSEC de $HOSTNAME copiada"
else
  Debug "Error al copiar clave IPSEC de $HOSTNAME" 
  Debug "La clave debe estar generada en $HOSTNAME, en $ARCH"
  Debug "Verifique el funcionamiento del servicio ssh en $HOSTNAME" 
  exit 2
fi


