#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: R1-1-preparar.sh 
# Descripcion: 	Permite configurar la red para el host 1
# Parametros: Ninguno
#
# Pre-Requisito: archivo de configuracion y archivo de funciones
#
# Valores de Retorno
#	0 - OK
#	Ver valores de retorno de los archivos requeridos
#====================================================================================================
#Version log:
#-----------
#02/02/2009: Creacion del script:  Hugo Pagola
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

hostname $H1_HOSTNAME
Debug "Hostname $H1_HOSTNAME configurado"

killall dhclient3

# Configuro Interfaces de red
ifconfig eth0 $H1_IP netmask $H1_MASCARA
Debug "Interfaz eth0 configurada con IP $H1_IP"

route add -net $R2_PRIV_RED netmask $R2_PRIV_MASCARA gw $R1_PRIV_IP
Debug "ruta default $R2_PRIV_RED netmask $R2_PRIV_MASCARA gw $R1_PRIV_IP Agregada"


# Armo la tabla de hosts
BackupArch /etc/hosts
rm -f /etc/hosts
(
        echo "127.0.0.1         localhost"
        echo "$H1_IP        $H1_HOSTNAME"
        echo "$H2_IP        $H2_HOSTNAME"
	echo "$R1_PRIV_IP   $R1_HOSTNAME"
) > $ARCHIVO_HOSTS
Debug "Tabla de hosts creada (/etc/hosts)"

