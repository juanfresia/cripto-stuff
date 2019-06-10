#!/bin/sh

echo "Reiniciando apache2"
/usr/bin/sudo /etc/init.d/apache2 force-reload
echo "Listo"

