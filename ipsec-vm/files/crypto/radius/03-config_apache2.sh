#!/bin/sh

DATA_FILE=data/etc/apache2.tgz
TARGET_DIR=/etc/apache2/

if [ ! -r ${DATA_FILE} ]; then
    echo "File access error: ${DATA_FILE}"
    exit 1
fi

/usr/bin/sudo tar zxf ${DATA_FILE} -C ${TARGET_DIR}

DATA_FILE=sites/radius-site.tgz
TARGET_DIR=/var/sites

if [ ! -d /var/sites ]; then
    sudo mkdir /var/sites
    sudo chmod 755 /var/sites
fi

/usr/bin/sudo tar zxf ${DATA_FILE} -C ${TARGET_DIR}

/usr/bin/sudo /etc/init.d/apache2 restart

echo "Configuracion de apache2 finalizada."
