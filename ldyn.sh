#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"
DEFAULT_TABLE="${DEFAULT_TABLE:-Config}"


function list_configs () {
  # aws dynamodb scan --table-name ${1} --projection-expression "lambda_name" --profile ${2} --output json | jq -r '.Items[].lambda_name.S' | sort
	aws dynamodb scan --table-name ${1} --projection-expression "lambda_name" --profile ${2} --output text --query 'Items[].[lambda_name.S]' | sort
}

function help_menu () {
cat << EOF
Usage: ${0} (-t [dynamodb_table_name] | -p [aws_profile_name])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use
   -t|--table-name           DynamoDB table name

EXAMPLES:
   List DynamoDB configs in given table using the given AWS profile:
        $ ldyn -t lambda-config -p tkt_prod_ro

   List DynamoDB configs in default table using default AWS profile:
        $ ldyn

NOTE:
   Requires aws cli and jq being installed.
EOF
}

while [[ $# > 0 ]]
do
case "${1}" in
  -p|--profile)
  DEFAULT_PROFILE=${2:-${DEFAULT_PROFILE}}
  shift
  ;;
  -t|--table-name)
  DEFAULT_TABLE=${2:-${DEFAULT_TABLE}}
  shift
  ;;
  -h|--help)
  help_menu
  exit 0
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  exit 1
  ;;
esac
shift
done

list_configs ${DEFAULT_TABLE} ${DEFAULT_PROFILE}
