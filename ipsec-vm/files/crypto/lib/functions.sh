#!/bin/bash
Debug() {
  # Muestra un mensaje anteponiendo prefijo
  MENSAJE="$@"
  echo ">>>>>> $MENSAJE" > /dev/tty
}


BackupArch() {
  # Muestra un mensaje anteponiendo prefijo
  arch="$@"
  if [ -e $arch ]
  then
  	yes | cp $arch $arch.1
  fi
}
