#!/bin/bash

function help_menu () {
cat << EOF
Usage: ${0} <Jenkins_project_name_to_build>

EXAMPLES:
   Cat console output of last job of Jenkins project 'log-shipper'
        $ ./jenkins-cat.sh log-shipper
EOF
}

if [[ $# == 0 ]]
then
        help_menu
        exit 0
fi



PROJECT=$1

java -jar /home/deepakt/Documents/dev/tools/jenkins-cli.jar -s http://10.123.0.88:8080 console ${PROJECT} --username deepakt --password 'A!rc0ol6r'
