#!/bin/sh

for i in ` ls [0-9][0-9]*.sh `
do
    if [ -x ${i} ]; then
        echo "Executing ${i}..."
        ./${i}
    else
        echo "${i} is not executable, skiping it!"
    fi
done

