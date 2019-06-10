#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: R1-0-router.sh 
# Descripcion: 	El objetivo de este script iniciar el enlace configurado
# Parametros:Ninguno
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	Ver valores de retorno de los archivos requeridos
#  	Ver valores de retorno de $SCRIPTS_LIB/IPSEC-configurar.sh
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
#  Pre-Requisitos
CONF_FILE="../conf/config.sh"
FUNC_FILE="../lib/functions.sh"
if [ ! -e $FUNC_FILE -o ! -e $CONF_FILE ]
then
	echo "No se encontraron los archivos requeridos para ejecutar este script"
	echo -e "\t${CONF_FILE} \n\t${FUNC_FILE}"
fi

. $CONF_FILE
if [ $? -ne 0 ]; then
	exit $?
fi
. $FUNC_FILE
if [ $? -ne 0 ]; then
	exit $?
fi

Debug "Establecimiento de conexion IPSEC - Inicio"

Debug "Reiniciando servicio IPSEC..."
echo "/etc/init.d/ipsec restart"
/etc/init.d/ipsec restart

Debug "Esperando..."
sleep 10 

Debug "Estableciendo conexion..."
echo "ipsec auto --up crypto"
ipsec auto --up crypto

Debug "Establecimiento de conexion IPSEC - Fin"
