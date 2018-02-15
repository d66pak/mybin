#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"
DEFAULT_TABLE="${DEFAULT_TABLE:-Config}"


function describe_config () {
	/home/deepakt/Documents/dev/my_ve/bin/python /home/deepakt/Documents/dev/mybin/get_item.py ${1} ${2} ${3} | jq .
}

function help_menu () {
cat << EOF
Usage: ${0} -k dynamodb_item_key_name (-t [dynamodb_table_name] | -p [aws_profile_name])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use
   -t|--table-name           DynamoDB table name
   -k|--key                  DynamoDB item key name

EXAMPLES:
   Describe DynamoDB config of given key in given table using the given AWS profile:
        $ ldyn -k DataEnricher -t lambda_config -p tkt_prod_ro

   Describe DynamoDB config of given key in default table using default AWS profile:
        $ ldyn -k DataEnricher

NOTE:
   Requires aws cli and jq being installed.
EOF
exit 0
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
  -k|--key)
  KEY=${2}
  shift
  ;;
  -h|--help)
  help_menu
  shift
  ;;
  *)
  echo "${1} is not a valid flag, try running: ${0} --help"
  exit 1
  ;;
esac
shift
done

if [ "x$KEY" = "x" ]
then
	echo "Key is missing!, try running: ${0} --help"
	exit 1
fi

describe_config ${KEY} ${DEFAULT_TABLE} ${DEFAULT_PROFILE}
