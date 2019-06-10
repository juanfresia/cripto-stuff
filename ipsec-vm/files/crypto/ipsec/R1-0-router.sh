#!/bin/bash
#----------------------------------------------------------------------------------------------------
# 			    66.69 - Criptografia y Seguridad Informatica
# 			Facultad de Ingenieria - Universidad de Buenos Aires
#----------------------------------------------------------------------------------------------------
# Scripts: R1-0-router.sh 
# Descripcion: 	El objetivo de este script es configurar el Router1 de manera interactiva
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
# Script interactivo para el R1 

Pausa() {
  echo ">>> Presione (ENTER)..."
  read
}

echo ">>> Script de configuracion interactiva de R1"
Pausa


echo ">>> Paso 1 - preparacion del entorno"
echo ">>> Comprende la configuracion de parametros de red, tabla de hosts, y claves de usuario"
Pausa
echo ">>> Ejecutando: R1-1-preparar.sh"
./R1-1-preparar.sh
if [ $? -ne 0 ]; then
  exit $?
fi
Pausa

echo ">>> Paso 2 - creacion de claves IPSEC"
echo ">>> Comprende la generacion de claves IPSEC y archivos temporales para intercambio"
Pausa
echo ">>> Ejecutando R1-2-generarclaves.sh"
./R1-2-generarclaves.sh
Pausa

echo ">>> Paso 3 - Copiado de clave remota"
echo ">>> Obtiene la clave IPSEC del Router 2 y la copia al equipo local"
echo ">>> Recuerde que la clave debe estar generada en el otro equipo (Paso 2)"
Pausa
echo ">>> Ejecutando R1-3-obtenerclaveremota.sh"
./R1-3-obtenerclaveremota.sh
COPIADA=$?
while [ $COPIADA -ne 0 ]
do
  Pausa
  echo ">>> Intentando nuevamente..."
  ./R1-3-obtenerclaveremota.sh
  COPIADA=$?
done
Pausa

echo ">>> Paso 4 - Configuracion IPSEC"
echo ">>> Genera el archivo de configuracion IPSEC con las claves anteriores"
Pausa
echo ">>> R1-4-configurar.sh"
./R1-4-configurar.sh
Pausa

echo ">>> Fin del script" 

