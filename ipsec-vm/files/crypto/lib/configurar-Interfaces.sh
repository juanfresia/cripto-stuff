#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: configurar-Interfaces.sh 
# Descripcion: 	El objetivo de este script es configurar los dispositivos de red para el host pasado por 
#		parámetro
# Parametros:
#		$1 - Hostname
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
# Se da de baja el cliente de DHCP
#no es necesario mas  killall dhclient3

case "$HOSTNAME" in
	"$R1_HOSTNAME")
		# Configuro el prompt para mayor comodidad
		PS1='[$R1_HOSTNAME] `pwd` $ '

		# Configuro el nombre de HOST
		hostname $R1_HOSTNAME
		Debug "Hostname $R1_HOSTNAME configurado"

		# Configuro Interfaces de red
		Debug "Configurando Interfaz publica $R1_PUB_INTERFAZ"
		Debug "   ifconfig $R1_PUB_INTERFAZ $R1_PUB_IP netmask $R1_PUB_MASCARA"
		ifconfig $R1_PUB_INTERFAZ $R1_PUB_IP netmask $R1_PUB_MASCARA
		
		Debug "Configurando Interfaz privada $R1_PRIV_INTERFAZ"
		Debug "   ifconfig $R1_PRIV_INTERFAZ $R1_PRIV_IP netmask $R1_PRIV_MASCARA"
		ifconfig $R1_PRIV_INTERFAZ $R1_PRIV_IP netmask $R1_PRIV_MASCARA
		;;
	"$R2_HOSTNAME")
		# Configuro el prompt para mayor comodidad
		PS1='[$R2_HOSTNAME] `pwd` $ '

		# Configuro el nombre de HOST
		hostname $R2_HOSTNAME
		Debug "Hostname $R2_HOSTNAME configurado"

		# Configuro Interfaces de red
		Debug "Configurando Interfaz publica $R2_PUB_INTERFAZ"
		Debug "   ifconfig $R2_PUB_INTERFAZ $R2_PUB_IP netmask $R2_PUB_MASCARA"
		ifconfig $R2_PUB_INTERFAZ $R2_PUB_IP netmask $R2_PUB_MASCARA
		
		Debug "Configurando Interfaz privada $R2_PRIV_INTERFAZ"
		Debug "   ifconfig $R2_PRIV_INTERFAZ $R2_PRIV_IP netmask $R2_PRIV_MASCARA"
		ifconfig $R2_PRIV_INTERFAZ $R2_PRIV_IP netmask $R2_PRIV_MASCARA
		;;	
	*) 	echo "USO: $0 HOST_NAME "
		exit 2
		;;
esac
		
# Armo la tabla de hosts 
BackupArch $ARCHIVO_HOSTS
rm -f $ARCHIVO_HOSTS
(
	echo "127.0.0.1		localhost" 
	echo "$R1_PUB_IP	$R1_HOSTNAME" 
	echo "$R2_PUB_IP	$R2_HOSTNAME"
	echo "$H1_IP            $H1_HOSTNAME"
	echo "$H2_IP            $H2_HOSTNAME"
) > $ARCHIVO_HOSTS
Debug "Tabla de hosts creada ($ARCHIVO_HOSTS)"

# terminacion de proceso IPSEC si es que esta corriendo
if [ `pgrep -f ipsec | wc -l` -gt 0 ]
then
  Debug "Terminando procesos IPSEC" 
  /etc/init.d/ipsec stop
fi

