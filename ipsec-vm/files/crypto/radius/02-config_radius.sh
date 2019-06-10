#!/bin/sh

DATA_FILE=data/etc/freeradius.tgz
TARGET_DIR=/etc/freeradius/

if [ ! -r ${DATA_FILE} ]; then
    echo "File access error: ${DATA_FILE}"
    exit 1
fi

/usr/bin/sudo tar zxf ${DATA_FILE} -C ${TARGET_DIR}

echo -e "Reiniciando el servicio freeradius"
/usr/bin/sudo /etc/init.d/freeradius restart

TEST_USER="prueba"
TEST_PASS="prueba123"
RADIUS_HOST="localhost"
DB_DATABASE="radius"

echo "Creando usuario de prueba: radius://${TEST_USER}:${TEST_PASS}@${RADIUS_HOST}"
echo -e "INSERT INTO ${DB_DATABASE}.radcheck
	(UserName, Attribute, Value)
	values ('${TEST_USER}','User-Password','${TEST_PASS}')" |
		mysql -u root

echo "Testeando usuario de prueba"
radtest ${TEST_USER} ${TEST_PASS} localhost 0 testing123
echo "Configuracion radius finalizada.\n"


