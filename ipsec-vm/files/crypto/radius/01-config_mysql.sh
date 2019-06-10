#!/bin/sh

DB_HOST="localhost"
DB_USER="radius"
DB_PASS="radius123"

DB_DATABASE="radius"
DB_TEMPLATE="data/radius.sql"

RADIUS_HOST="localhost"

mysqlRadiusUser="radius"
# Password del usuario con el que el RADIUS server accede a la DB MySQL
mysqlRadiusPass="radius123"

echo -e "Creando base de datos MySQL: ${DB_DATABASE}"
mysqladmin -u root create ${DB_DATABASE}

if [[ ! -r ${DB_TEMPLATE} ]]; then
	echo "File access error: ${DB_TEMPLATE}"
	exit 0
fi
echo -e "Importando tablas: archivo ${DB_TEMPLATE}"
mysql -u root ${DB_DATABASE} < ${DB_TEMPLATE}

echo -e "Creando usuario mysql://${DB_USER}@${DB_HOST}"
echo -e "GRANT USAGE,SELECT,INSERT,DELETE
	ON ${DB_DATABASE}.*
	TO ${DB_USER}@${DB_HOST}
	identified by '${DB_PASS}'" | mysql -u root

echo "Configuracion MySQL finalizada\n"

