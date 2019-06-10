#! /bin/bash

./s00-configurarInterfacesLocales.sh
./s01-generarCA.sh
./s02-generaSolicitudes.sh
./s03-firmaSolicitudes.sh
./s04-generaCRL.sh
./s05-getIDs.sh
./s06-instalaCertificados.sh
./s07-preparaArchivo.sh
./s10c-generarIPsecConf.sh
./s11c-generarIPsecSec.sh

