#!/bin/bash

DEFAULT_PROFILE="${DEFAULT_PROFILE:-default}"


function describe_lambda () {
	aws lambda get-function-configuration --function-name ${1} --profile ${2} | jq .
        echo -e "\n\nEvent Source Mapping"
        echo "------------------------"
	aws lambda list-event-source-mappings --function-name ${1} --profile ${2} | jq .
}

function help_menu () {
cat << EOF
Usage: ${0} -f lambda_function_name (-p [aws_profile_name])

ENVIRONMENT VARIABLES:
   DEFAULT_PROFILE  Default AWS profile to use. Default is 'default'

OPTIONS:
   -h|--help                 Show this message
   -p|--profile              AWS profile to use
   -f|--function-name        AWS Lambda function name

EXAMPLES:
   Describe AWS Lambda functions in the given profile:
        $ dlam -f DataEnricher -p tkt_prod_ro

   Describe AWS Lambda functions in the default profile:
        $ dlam -f DataEnricher

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
  -f|--function-name)
  FUNCTION_NAME=${2}
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

if [ "x$FUNCTION_NAME" = "x" ]
then
	echo "function-name is missing!, try running: ${0} --help"
	exit 1
fi

describe_lambda ${FUNCTION_NAME} ${DEFAULT_PROFILE}
