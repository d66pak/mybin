#!/bin/bash

function help_menu () {
cat << EOF
Usage: ${0} [Jenkins_View_name]

EXAMPLES:
   List jobs under view 'Vista'
        $ ./jenkins-ls.sh Vista

   List all jobs/views
        $ ./jenkins-ls.sh
EOF
}

JOB=$1

java -jar /home/deepakt/Documents/dev/tools/jenkins-cli.jar -s http://10.123.0.88:8080 list-jobs ${JOB} --username deepakt --password 'A!rc0ol6r'
